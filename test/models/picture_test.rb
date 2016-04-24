require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  def setup
    @ivan = Employee.create(name: 'Ivan')
    @michael = Employee.create(name: 'Michael')

    @osx = Product.create(name: 'OS X')
    @windows = Product.create(name: 'Windows')

    @ivan_avatar = Picture.create(name: "Ivan's avatar", imageable: @ivan)
    @michael_avatar = Picture.create(name: "Michael's avatar", imageable: @michael)

    @osx_logo = Picture.create(name: 'OS X Logo', imageable: @osx)
    @windows_logo = Picture.create(name: 'Windows Logo', imageable: @windows)
  end

  test 'polymorphic association negation' do
    images = Picture.where.not(imageable: @ivan).order(:name)
    puts images.to_sql
    # All images, except ivan_avatar should be found
    assert_equal images, [@michael_avatar, @osx_logo, @windows_logo]
  end

  test 'polymorphic association negation fixed' do
    images = Picture
      .where( "imageable_type <> ? or imageable_id <> ?", @ivan.class.name, @ivan.id)
      .order(:name)
    # All images, except ivan_avatar should be found
    assert_equal images, [@michael_avatar, @osx_logo, @windows_logo]
  end
end
