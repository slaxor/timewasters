#!/usr/bin/env ruby
# frozen_string_literal: true
require 'minitest/autorun'
require File.expand_path(__FILE__.sub(/_spec/, ''))
require 'minitest/reporters'
reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

class Array
  # makes shuffle deterministic for testing
  alias :shuffleorig :shuffle

  def shuffle
    @rnd ||= Random.new(1)
    shuffleorig(random: @rnd)
  end
end

describe 'Team' do
  let(:described_class) { Team }
  let(:instance) { described_class.new }
  let(:members) do
    [
      Team::Member.new("foo"),
      Team::Member.new("bar")
    ]
  end

  def catch_stdout
    $stdout = StringIO.new
    yield
    $stdout.seek(0)
    capture = $stdout.read
    $stdout = STDOUT
    capture
  end

  describe '#initialize' do
    it 'must set @members' do
      instance.instance_variable_get(:@members).must_equal([])
    end
  end

  describe '#<<' do
    it 'must add a member to @members' do
      instance << "foobar"
      instance.instance_variable_get(:@members).must_equal([Team::Member.new("foobar")])
    end
  end

  describe '#members_names' do
    it 'must return all @members names' do
      instance.instance_variable_set(:@members, members)
      instance.members_names.must_equal(["foo", "bar"])
    end
  end

  describe '#pro_print' do
    it 'must return @members names' do
      instance.instance_variable_set(:@members, members)
      printed = catch_stdout { instance.pro_print }
      # require 'pry'; binding.pry
      printed.must_equal("Foo\nBar\n")
    end

    it 'must honor the limit param' do
      instance.instance_variable_set(:@members, members * 10)
      printed = catch_stdout { instance.pro_print }
      printed.must_equal("Foo\nBar\n" * 5)
      printed = catch_stdout { instance.pro_print(4) }
      printed.must_equal("Foo\nBar\n" * 2)
    end
  end

  describe '#reverse_print' do
    it 'must print tac`ed @members names' do
      instance.instance_variable_set(:@members, members)
      printed = catch_stdout { instance.reverse_print }
      printed.must_equal("rab\noof\n")
    end
  end

  describe '#funny_print' do
    it 'must have a method definition' do
      instance.must_respond_to(:funny_print)
    end

    it 'must print @members names stepping up on the screen' do
      unless ENV['DOSLOWTESTING']
        skip_text = "This takes about 25sec to run. If you want"
        skip_text += " it anyway call the test like so:\n\n"
        skip_text += "DOSLOWTESTING=true #{__FILE__}"
        skip(skip_text)
      end
      instance.instance_variable_set(:@members, members * 2)
      printed = catch_stdout { instance.funny_print }
      printed.must_match(/Rise and shine/)
      printed.must_match(/foo, bar, foo, bar/)
    end
  end

  describe '#presentation' do
    it 'must print shuffled @members names with header and asterisks' do
      instance.instance_variable_set(:@members, members * 2)
      printed = catch_stdout { instance.presentation }
      printed.must_equal("Members:\n* bar\n* foo\n* foo\n* bar\n")
    end

    it 'must print @members names with header and asterisks (plain)' do
      instance.instance_variable_set(:@members, members * 2)
      printed = catch_stdout { instance.presentation(:plain) }
      printed.must_equal("Members:\n* foo\n* bar\n* foo\n* bar\n")
    end

    [:shuffle, :plain, :funny, :reverse, :pro].each do |how|
      it "must print @members names with header and asterisks (#{how})" do
        receptor = "#{how}_print".to_sym
        instance.stub(receptor, true) do
          instance.presentation(how).must_equal(true)
        end
      end
    end
  end
end

