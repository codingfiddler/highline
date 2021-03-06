#!/usr/bin/env ruby
# coding: utf-8

require "test_helper"

require "highline"

class TestHighLinePaginator < Minitest::Test
  def setup
    HighLine.reset
    @input    = StringIO.new
    @output   = StringIO.new
    @terminal = HighLine.new(@input, @output)
  end

  def test_paging
    @terminal.page_at = 22

    @input << "\n\n"
    @input.rewind

    @terminal.say((1..50).map { |n| "This is line #{n}.\n" }.join)
    assert_equal((1..22).map { |n| "This is line #{n}.\n" }.join +
                  "\n-- press enter/return to continue or q to stop -- \n\n" +
                  (23..44).map { |n| "This is line #{n}.\n" }.join +
                  "\n-- press enter/return to continue or q to stop -- \n\n" +
                  (45..50).map { |n| "This is line #{n}.\n" }.join,
                 @output.string)
  end

  def test_statement_lines_count_equal_to_page_at_shouldnt_paginate
    @terminal.page_at = 6

    @input << "\n"
    @input.rewind

    list = "a\nb\nc\nd\ne\nf\n"

    @terminal.say(list)
    assert_equal(list, @output.string)
  end

  def test_statement_with_one_line_bigger_than_page_at_should_paginate
    @terminal.page_at = 6

    @input << "\n"
    @input.rewind

    list = "a\nb\nc\nd\ne\nf\ng\n"

    paginated =
      "a\nb\nc\nd\ne\nf\n" \
      "\n-- press enter/return to continue or q to stop -- \n\n" \
      "g\n"

    @terminal.say(list)
    assert_equal(paginated, @output.string)
  end

  def test_quiting_paging_shouldnt_raise
    # See https://github.com/JEG2/highline/issues/168

    @terminal.page_at = 6

    @input << "q"
    @input.rewind

    list = "a\nb\nc\nd\ne\nf\n"

    # expect not to raise an error on next line
    @terminal.say(list)
  end
end
