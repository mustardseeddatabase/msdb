describe "Initial condition", ->
  beforeEach ->
    loadFixtures "fancy_text_box"

  it "should render a table element", ->
    expect($('.fancy_text_box')).toExist()

  it "the clear control should not be visible", ->
    expect($('.text_clear')).toBeHidden()

describe "When text is entered", ->
  beforeEach ->
    loadFixtures "fancy_text_box"
    ftb = new FancyTextBox
    $('.text_input').val('some text')
    $('.text_input').keyup()

  it "the clear control should be visible", ->
    expect($('.text_clear')).toBeVisible()
    $('.text_input').val('')
    $('.text_input').keyup()
    expect($('.text_clear')).toBeHidden()

describe "When clear is clicked", ->
  beforeEach ->
    loadFixtures "fancy_text_box"
    ftb = new FancyTextBox
    $('.text_input').val('some text')
    $('.text_input').keyup()
    $('.text_clear').click()

  it "should clear the text field", ->
    expect($('.text_input')).toHaveValue('')
    expect($('.text_clear')).toBeHidden()

describe "When a callback is specified", ->
  beforeEach ->
    loadFixtures "fancy_text_box"
    test_callback = -> $('.fancy_text_box').after("<p id='test_callback' >some other text</p>")
    ftb = new FancyTextBox(test_callback)
    $('.text_input').val('some text')
    $('.text_input').keyup()
    $('.text_clear').click()

  it "should call the specified callback", ->
    expect($('#test_callback')).toExist()

describe "When there are multiple fancy text boxes on a page", ->
  beforeEach ->
    loadFixtures "double_fancy_text_box"
    ftb = new FancyTextBox
    $("[class='text_input'][id='first']").val('some text')
    $("[class='text_input'][id='first']").keyup()

  it "the first clear control should be visible", ->
    expect($('.text_clear').first()).toBeVisible()

  it "the second clear control should be hidden", ->
    expect($('.text_clear').last()).toBeHidden()

describe "When there are multiple fancy text boxes on a page, all with text content", ->
  beforeEach ->
    loadFixtures "double_fancy_text_box"
    ftb = new FancyTextBox
    $("[class='text_input'][id='first']").val('some text')
    $("[class='text_input'][id='first']").keyup()
    $("[class='text_input'][id='second']").val('some more text')
    $("[class='text_input'][id='second']").keyup()

  it "should have both text fields and both controls visible", ->
    expect($('.text_input').first()).toHaveValue('some text')
    expect($('.text_input').last()).toHaveValue('some more text')
    expect($('.text_clear').first()).toBeVisible()
    expect($('.text_clear').last()).toBeVisible()

  it "should clear the first text field", ->
    $('.text_clear').first().click()
    expect($('.text_input').first()).toHaveValue('')

  it "should not clear the second text field", ->
    $('.text_clear').first().click()
    expect($('.text_input').last()).toHaveValue('some more text')

  it "the first clear control should be hidden", ->
    $('.text_clear').first().click()
    expect($('.text_clear').first()).toBeHidden()

  it "the second clear control should be visible", ->
    $('.text_clear').first().click()
    expect($('.text_clear').last()).toBeVisible()
    expect($('.text_input')).toHaveValue('')


describe "When there are multiple fancy text boxes on a page, all with text content", ->
  beforeEach ->
    loadFixtures "double_fancy_text_box"
    ftb = new FancyTextBox
    $("[class='text_input'][id='first']").val('some text')
    $("[class='text_input'][id='first']").keyup()
    $("[class='text_input'][id='second']").val('some more text')
    $("[class='text_input'][id='second']").keyup()

  it "should have both text fields and both controls visible", ->
    expect($('.text_input').first()).toHaveValue('some text')
    expect($('.text_input').last()).toHaveValue('some more text')
    expect($('.text_clear').first()).toBeVisible()
    expect($('.text_clear').last()).toBeVisible()

  it "when one field is cleared, its control should be hidden and the other should be visible", ->
    $("[class='text_input'][id='first']").val('')
    $("[class='text_input'][id='first']").keyup()
    expect($('.text_input').first()).toHaveValue('')
    expect($('.text_input').last()).toHaveValue('some more text')
    expect($('.text_clear').first()).toBeHidden()
    expect($('.text_clear').last()).toBeVisible()
