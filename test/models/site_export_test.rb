require 'test_helper'

class SiteExportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @site_export = site_exports(:one)
  end

  test "should set progress" do
    @site_export.update_progress!('testing', 53)

    assert_equal '53', site_exports(:one).progress
  end

  test "should set error status" do
    @site_export.export_error('testing')

    assert_equal 'error', @site_export.status
  end

  test "should set status to running" do
    @site_export.start

    assert_equal 'started', @site_export.status
    assert_equal '0', @site_export.progress
  end

  test "should set status to complete" do
    @site_export.complete

    assert_equal 'completed', @site_export.status
    assert_equal '100', @site_export.progress
  end

  test "should be running?" do
    @site_export.start

    assert @site_export.running?, 'Was not set as running'
  end

  test "should be completed" do
    @site_export.complete

    assert @site_export.completed?, 'Was not set as completed'
  end
end
