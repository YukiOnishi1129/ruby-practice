require 'minitest/autorun'

class TestSample < Minitest::Test
    def test_sample
        # assert_equal 期待する結果, テスト対象となる値や式
        assert_equal 'RUBY', 'ruby'.upcase
    end
end