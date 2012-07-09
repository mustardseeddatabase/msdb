describe "Waive the requirements for each client and qualification document in sequence", ->
  beforeEach ->
    loadFixtures 'client_quickcheck'

  it "should increment the warning count for each client and each qualification document in sequence", ->
    expect($($('.count')[0])).toHaveText("0")
    $('#warn').click()
    expect($($('.count')[0])).toHaveText("1")

    expect($($('.count')[1])).toHaveText("0")
    $('#warn').click()
    expect($($('.count')[1])).toHaveText("1")

    expect($($('.count')[2])).toHaveText("0")
    $('#warn').click()
    expect($($('.count')[2])).toHaveText("1")

    expect($($('.count')[3])).toHaveText("0")
    $('#warn').click()
    expect($($('.count')[3])).toHaveText("1")

    expect($($('.count')[4])).toHaveText("0")
    $('#warn').click()
    expect($($('.count')[4])).toHaveText("1")

    expect($($('.count')[5])).toHaveText("0")
    $('#warn').click()
    expect($($('.count')[5])).toHaveText("1")
