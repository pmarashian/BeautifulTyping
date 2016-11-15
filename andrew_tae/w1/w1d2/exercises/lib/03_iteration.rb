require "byebug"
# ### Factors
#
# Write a method `factors(num)` that returns an array containing all the
# factors of a given number.

def factors(num)
  i = 1
  factor = []
  until i == num + 1
    if num%i == 0
      factor << i 
    end

    i += 1
  end
  factor

end

# ### Bubble Sort
#
# http://en.wikipedia.org/wiki/bubble_sort
#
# Implement Bubble sort in a method, `Array#bubble_sort!`. Your method should
# modify the array so that it is in sorted order.
#
# > Bubble sort, sometimes incorrectly referred to as sinking sort, is a
# > simple sorting algorithm that works by repeatedly stepping through
# > the list to be sorted, comparing each pair of adjacent items and
# > swapping them if they are in the wrong order. The pass through the
# > list is repeated until no swaps are needed, which indicates that the
# > list is sorted. The algorithm gets its name from the way smaller
# > elements "bubble" to the top of the list. Because it only uses
# > comparisons to operate on elements, it is a comparison
# > sort. Although the algorithm is simple, most other algorithms are
# > more efficient for sorting large lists.
#
# Hint: Ruby has parallel assignment for easily swapping values:
# http://rubyquicktips.com/post/384502538/easily-swap-two-variables-values
#
# After writing `bubble_sort!`, write a `bubble_sort` that does the same
# but doesn't modify the original. Do this in two lines using `dup`.
#
# Finally, modify your `Array#bubble_sort!` method so that, instead of
# using `>` and `<` to compare elements, it takes a block to perform the
# comparison:
#
# ```ruby
# [1, 3, 5].bubble_sort! { |num1, num2| num1 <=> num2 } #sort ascending
# [1, 3, 5].bubble_sort! { |num1, num2| num2 <=> num1 } #sort descending
# ```
#
# #### `#<=>` (the **spaceship** method) compares objects. `x.<=>(y)` returns
# `-1` if `x` is less than `y`. If `x` and `y` are equal, it returns `0`. If
# greater, `1`. For future reference, you can define `<=>` on your own classes.
#
# http://stackoverflow.com/questions/827649/what-is-the-ruby-spaceship-operator

class Array
  def bubble_sort!
    sorted = false
    if self == []
      return []
    end

    until sorted == true
      sorted = true
      idx1 = 0
      until idx1 == self.length-1
        if block_given?
          if yield(self[idx1], self[idx1+1]) == 1
            sorted = false

            self[idx1], self[idx1 + 1] = self[idx1 + 1], self[idx1]
          end
        elsif self[idx1] > self[idx1 + 1]
          sorted = false         
        
          self[idx1], self[idx1 + 1] = self[idx1 + 1], self[idx1]
        end
        idx1 += 1
      end
    end

   self
  end

  def bubble_sort(&prc)
    self.dup.bubble_sort!
  end

end

# ### Substrings and Subwords
#
# Write a method, `substrings`, that will take a `String` and return an
# array containing each of its substrings. Don't repeat substrings.
# Example output: `substrings("cat") => ["c", "ca", "cat", "a", "at",
# "t"]`.
#
# Your `substrings` method returns many strings that are not true English
# words. Let's write a new method, `subwords`, which will call
# `substrings`, filtering it to return only valid words. To do this,
# `subwords` will accept both a string and a dictionary (an array of
# words).

def substrings(string)
  idx1 = 0
  substrings = []
  until idx1 == string.length
    idx2 = idx1
    until idx2 == string.length
      substrings << string[idx1..idx2]
      idx2 += 1
    end

    idx1 += 1
  end

  substrings

end

def subwords(word, dictionary)
  split = substrings(word)
  real_words = []
  split.each do |word|
    if dictionary.include?(word)
      real_words << word
    end
  end
  real_words.uniq
end

# ### Doubler
# Write a `doubler` method that takes an array of integers and returns an
# array with the original elements multiplied by two.

def doubler(array)
  doubled = []
  array.each do |value|
    doubled << value * 2
  end

  doubled

end

# ### My Each
# Extend the Array class to include a method named `my_each` that takes a
# block, calls the block on every element of the array, and then returns
# the original array. Do not use Enumerable's `each` method. I want to be
# able to write:
#
# ```ruby
# # calls my_each twice on the array, printing all the numbers twice.
# return_value = [1, 2, 3].my_each do |num|
#   puts num
# end.my_each do |num|
#   puts num
# end
# # => 1
#      2
#      3
#      1
#      2
#      3
#
# p return_value # => [1, 2, 3]
# ```

class Array
  def my_each(&prc)
    i = 0
    until i == self.length  
      prc.call(self[i])
      i += 1
    end
    self
  end
end

# ### My Enumerable Methods
# * Implement new `Array` methods `my_map` and `my_select`. Do
#   it by monkey-patching the `Array` class. Don't use any of the
#   original versions when writing these. Use your `my_each` method to
#   define the others. Remember that `each`/`map`/`select` do not modify
#   the original array.
# * Implement a `my_inject` method. Your version shouldn't take an
#   optional starting argument; just use the first element. Ruby's
#   `inject` is fancy (you can write `[1, 2, 3].inject(:+)` to shorten
#   up `[1, 2, 3].inject { |sum, num| sum + num }`), but do the block
#   (and not the symbol) version. Again, use your `my_each` to define
#   `my_inject`. Again, do not modify the original array.

class Array
  def my_map(&prc)
   i = 0
   newArray = []
    until i == self.length  
      newArray << prc.call(self[i])
      i += 1
    end

    newArray
  end

  def my_select(&prc)
   i = 0
   newArray = []
    until i == self.length  
      if prc.call(self[i])
        newArray << self[i]
      end
      i += 1
    end

    newArray
  end

  def my_inject(default = false, &blk)
    i = 0
    newArray = []
    
    unless default
      accumulator = self[0]
      i = 1
    end

    until i == self.length 
      accumulator = yield(accumulator,self[i]) 
      i += 1
    end

    newArray
  end
end

# ### Concatenate
# Create a method that takes in an `Array` of `String`s and uses `inject`
# to return the concatenation of the strings.
#
# ```ruby
# concatenate(["Yay ", "for ", "strings!"])
# # => "Yay for strings!"
# ```

def concatenate(strings)
  strings.inject(:+)
end