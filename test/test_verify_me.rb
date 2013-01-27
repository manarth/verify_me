require 'test/unit'
require 'verify_me'

class VerifyMeTest < Test::Unit::TestCase
  def test_calculateOverlayPosition
    # These overlay calulations are tested against the following accounts:
    # - bengoldacre   ben goldacre        (JPEG image)
    # - shakira       Shakira         295 (PNG image)
    # - therealgokwan Gok Wan         302 (no background image)
    # - therealdcf1   David Coulthard 343 (no background image)
    # - notch         Markus Persson  344


    # bounding box is 442px wide and offset by 39px, centered at 260px.
    # Verified img is 21px wide
    #      1 space is  7px wide
                   # dist from 260
                   
    # width  act pos
    #  86 => 295       d=209  x=35     y=153
    # 104 => 302       d=198  x=42     y=135
    # 183 => 343       d=160  x=83     y= 56
    # 186 => 344       d=158  x=84     y= 53



    # POS of RHS     delta from 260  inferred width  reported width   delta
    #   316                56             112              86           26
    #   323                63             126             104           22
    #   364               104             208             183           25
    #   365               105             210             186           24

    #     Foo bar [o]

# 260 + ((x + 21 + 10) / 2) - 21
# 239 + 

    assert_equal [302, 109],
      VerifyMe::calculateOverlayPosition('Gok Wan')

    assert_equal [343, 109],
      VerifyMe::calculateOverlayPosition('David Coulthard')

    # assert_equal [343, 109],
    #   VerifyMe::calculateOverlayPosition('ben goldacre')

    assert_equal [295, 109],
      VerifyMe::calculateOverlayPosition('Shakira')

    assert_equal [344, 109],
      VerifyMe::calculateOverlayPosition('Markus Persson')
  end


end