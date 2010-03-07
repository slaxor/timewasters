module Collatz
  def collatz(last = [])
    if self == 1
      last << self
    else
      (self.odd? ? 3 * self + 1 : self / 2).collatz(last << self)
    end
    last
  end
end
