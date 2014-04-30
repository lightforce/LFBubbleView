Pod::Spec.new do |s|
  s.name         = 'LFBubbleView'
  s.version      = '1.0.0'
  s.license      = 'BSD'
  s.homepage     = 'https://github.com/lightforce/LFBubbleView.git'
  s.authors      = { 'Sebastian Hunkeler' => 'hunkeler.sebastian@gmail.com' }
  s.summary      = 'A bubble view for iOS based on UICollectionView'
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/lightforce/LFBubbleView.git', :tag => '1.0.0' }
  s.source_files = 'LFBubbleView/LFBubbleCollectionViewCell.{h,m}', 'LFBubbleCollectionView.{h,m}', 'LFBubbleCollectionViewController.{h,m}', 'Pods/NHAlignmentFlowLayout/NHAlignmentFlowLayout/NHAlignmentFlowLayout.{h,m}'
  s.requires_arc = true
end
