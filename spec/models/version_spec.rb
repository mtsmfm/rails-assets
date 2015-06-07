require 'spec_helper'

describe Version do
  context '.latest_rev' do
    it 'returns latest revision versions' do
      included = []

      a = Component.create!(name: 'a')
      b = Component.create!(name: 'b')

      a.versions.create!(string: '1.0.2',   bower_version: '1.0.2')
      included << a.versions.create!(string: '1.0.1',   bower_version: '1.0.1')
      included << a.versions.create!(string: '1.0.2.1', bower_version: '1.0.2')
      included << b.versions.create!(string: '1.0.2',   bower_version: '1.0.2')

      expect(Version.latest_rev.map(&:id)).to match_array included.map(&:id)
    end
  end

  context '#gem_path' do
    it 'returns absolute path to gem on disk' do
      component = Component.new(name: 'jquery')
      version = Version.new(string: '1.0.2')
      version.component = component

      expect(version.gem_path.to_s).
        to include('public/gems/rails-assets-jquery-1.0.2.gem')
    end
  end
end
