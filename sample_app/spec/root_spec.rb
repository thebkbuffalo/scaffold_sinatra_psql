describe("the root") do
  it "says Hello from Index!" do
    visit("/")
    expect(page).to have_content("Hello from Index!")
  end
end
