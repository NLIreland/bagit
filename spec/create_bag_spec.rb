require 'spec_helper'

describe "create a new bag" do
  context "when the directory does not exist" do
    context "when an info hash is NOT passed in" do
      before(:each) do

        @sandbox = Sandbox.new

        # make the bag
        @bag_path = File.join @sandbox.to_s, 'the_bag'
        @bag = BagIt::Bag.new @bag_path
      end

      after(:each) do
        @sandbox.cleanup!
      end


      it "should not have a bagit.txt file" do
        File.join(@bag_path, 'bagit.txt').should_not exist_on_fs
      end

      it "should not have a bag-info.txt file" do
        File.join(@bag_path, 'bag-info.txt').should_not exist_on_fs
      end

      it "should not have a directory bag path" do
        @bag_path.should_not exist_on_fs
      end

      it "should not have a directory data path" do
        File.join(@bag_path, '/data').should_not exist_on_fs
      end

      it "should not have any manifest.txt files" do
        File.join(@bag_path, '*manifest-*.txt').should_not exist_on_fs
      end

      it "should not have any tagmanifest.txt files" do
        File.join(@bag_path, '*tagmanifest-*.txt').should_not exist_on_fs
      end
    end

    context "when an info hash is passed in" do
      before(:each) do

        @sandbox = Sandbox.new

        # make the bag
        @bag_path = File.join @sandbox.to_s, 'the_bag'
        @bag = BagIt::Bag.new @bag_path, {'File-System-Group' => 'Hash-Example'}

      end

      after(:each) do
        @sandbox.cleanup!
      end


      it "should not have a bagit.txt file" do
        File.join(@bag_path, 'bagit.txt').should_not exist_on_fs
      end

      it "should have a bag-info.txt file" do
        File.join(@bag_path, 'bag-info.txt').should exist_on_fs
      end

      it "should not have a directory bag path" do
        @bag_path.should exist_on_fs
      end

      it "should not have a directory data path" do
        File.join(@bag_path, '/data').should_not exist_on_fs
      end

      it "should not have any manifest.txt files" do
        File.join(@bag_path, '*manifest-*.txt').should_not exist_on_fs
      end

      it "should not have any tagmanifest.txt files" do
        File.join(@bag_path, '*tagmanifest-*.txt').should_not exist_on_fs
      end
    end

  end
end
