#!/usr/bin/env ruby
# frozen_string_literal: true
require 'minitest/autorun'
require File.expand_path(__FILE__.sub(/_spec/, ''))
require 'webmock/minitest'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new({ color: true })]

WebMock.enable!
WebMock.disable_net_connect!

describe 'Bookapp' do
  let(:described_class) { Bookapp }
  let(:instance) { described_class.new('foo bar') }

  before do
    f = File.open('test_response.raw', 'r') # generate with curl -is "<url>"
    stub_request(:get, /www.googleapis.com/).to_return(f)
  end

  describe '#initialize' do
    it 'returns an instance with @url filled' do
      instance.instance_variable_get(:@url).must_match(%r(https://www.googleapis.com.*foo%20bar))
    end
  end

  describe '#fetch' do
    it 'sends a request to the api url' do
      instance.fetch
      instance.instance_variable_get(:@result)['totalItems'].must_equal(303)
    end
  end

  describe '#parse' do
    it 'converts the relevant entries into a ruby collection' do
      instance.fetch
      instance.parse[3].must_equal('Einführung in LaTeX')
    end
  end

  describe '#result' do
    it 'picks the titles only and returns them as array' do
      instance.result.must_equal([
                                   "DNS und BIND",
                                   "Software-Qualität",
                                   "Writing Idiomatic Python 3.3",
                                   "Einführung in LaTeX",
                                   "Professional AngularJS",
                                   "Practical Common Lisp",
                                   "Dojo: The Definitive Guide",
                                   "Common LISP",
                                   "The GNU Make Book",
                                   "DNS and BIND"
                                 ])
    end
  end

  describe '#pretty_result' do
    it 'formats the result in a numbered list' do
      instance.pretty_result.must_equal(
        "    1: DNS und BIND\n" +
        "    2: Software-Qualität\n" +
        "    3: Writing Idiomatic Python 3.3\n" +
        "    4: Einführung in LaTeX\n" +
        "    5: Professional AngularJS\n" +
        "    6: Practical Common Lisp\n" +
        "    7: Dojo: The Definitive Guide\n" +
        "    8: Common LISP\n" +
        "    9: The GNU Make Book\n" +
        "   10: DNS and BIND"
      )
    end
  end
end

