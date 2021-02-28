# puts "Hello, World!"
# puts 1 + 2

# コメント

=begin
    方
rescue => exception
    こんなコメントもできるのか
=end

# ダブルコートだと\nが改行として機能する
# puts "こんにちは\nさようなら"

# puts 'こんにちは\nさようなら'

# name = 'Alice'
# puts "Hello, #{name}"

# find_data = nil

# data = find_data

# if data != nil
#     puts 'データがあります'
# else
#     puts 'データがありません'
# end

def add(a, b)
    b = b + 1
    a + b
end

puts add(1, 2)