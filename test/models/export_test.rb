require 'test_helper'

class ExportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @export = exports(:one)
  end

  test "export should be valid" do
    assert @export.valid?
  end

  test "export without variables should not be valid" do
    export = Export.new
    assert_not export.valid?
  end

  test "should have a search object" do
    assert_not_nil @export.search
  end
end
