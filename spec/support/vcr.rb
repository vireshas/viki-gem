VCR.configure do |c|
  #c.cassette_library_dir = root.join("spec", "vcr")
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

