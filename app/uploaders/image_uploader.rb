# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "#{model.class.to_s.downcase}.png"].compact.join('_'))
  end

  version :large do
     process :resize_to_fill => [256, 256]
  end

  version :thumbnail do
     process :resize_to_fill => [128, 128]
  end

  version :icon do
     process :resize_to_fill => [64, 64]
  end

  version :icon32 do
     process :resize_to_fill => [32, 32]
  end

  version :icon16 do
     process :resize_to_fill => [16, 16]
  end

  def extension_white_list
     %w(jpg jpeg gif png)
  end
end