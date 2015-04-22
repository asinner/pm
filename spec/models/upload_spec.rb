require 'rails_helper'

RSpec.describe Upload, :type => :model do
  let(:upload) {FactoryGirl.create(:upload)}

  it 'is invalid without a title' do
    upload.title = nil
    expect(upload).to be_invalid
  end

  it 'is invalid without a user' do
    upload.user = nil
    expect(upload).to be_invalid
  end

  it 'is invalid without a size' do
    upload.size = nil
    expect(upload).to be_invalid
  end

  it 'is invalid over 50 megabytes' do
    upload.size = 50.megabytes + 1
    expect(upload).to be_invalid
  end

  it 'is invalid if not attached to anything' do
    upload.attachable = nil
    expect(upload).to be_invalid
  end

  it 'is invalid without a url' do
    upload.url = nil
    expect(upload).to be_invalid
  end


  it 'is invalid without a mime type' do
    upload.mime_type = nil
    expect(upload).to be_invalid
  end

  it 'is invalid without a key' do
    upload.key = nil
    expect(upload).to be_invalid
  end
end
