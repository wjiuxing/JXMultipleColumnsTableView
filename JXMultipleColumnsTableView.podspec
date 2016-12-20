Pod::Spec.new do |s|
  s.name         = "JXMultipleColumnsTableView"
  s.version      = "1.0.0"
  s.summary      = "A multiple columns table view based on CoreGraphics framework."
  s.description  = <<-DESC
			A multiple columns table view based on the CoreGraphics framework, which supports to  custom columns within link, image.
                   DESC
  s.homepage     = "https://github.com/wjiuxing/JXMultipleColumnsTableView"
  s.license      = "MIT"
  s.author       = { "Amos King" => "wangjiuxing2010@hotmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/wjiuxing/JXMultipleColumnsTableView.git", :tag => "v#{s.version}" }
  s.source_files  = "JXMultipleColumnsTableView"
  s.framework  = "UIKit"
  s.requires_arc = true
end
