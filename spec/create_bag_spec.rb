require 'spec_helper'

describe "create a new bag" do

  let(:pattern) {File.join @bag_path, 'manifest-*.txt'}
  let(:tag_pattern) {File.join @bag_path, 'tagmanifest-*.txt'}

  context "when the directory does NOT exist" do

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
        manifest_files = Dir.glob pattern
        manifest_files.count.should == 0
      end

      it "should not have any tagmanifest.txt files" do
        tagmanifest_files = Dir.glob tag_pattern
        tagmanifest_files.count.should == 0
      end

        context "when a file is added with the add_file method" do

          before(:each) do
            @bag.add_file('newfile.txt') { |io| io.puts("new file to bag data path") }
          end

          it "should not have a bagit.txt file" do
            File.join(@bag_path, 'bagit.txt').should_not exist_on_fs
          end

          it "should have a bag-info.txt file" do
            File.join(@bag_path, 'bag-info.txt').should exist_on_fs
          end

          it "should have a directory bag path" do
            @bag_path.should exist_on_fs
          end

          it "should have a directory data path" do
            File.join(@bag_path, '/data').should exist_on_fs
          end

          it "should not have any manifest.txt files" do
            manifest_files = Dir.glob pattern
            manifest_files.count.should == 0
          end

          it "should not have any tagmanifest.txt files" do
            tagmanifest_files = Dir.glob tag_pattern
            tagmanifest_files.count.should == 0
          end

            context "when manifest! is called on the bag" do

              before(:each) do
                @bag.manifest!
              end

              it "should have a bagit.txt file" do
                File.join(@bag_path, 'bagit.txt').should exist_on_fs
              end

              it "should have a bag-info.txt file" do
                File.join(@bag_path, 'bag-info.txt').should exist_on_fs
              end

              it "should have a directory bag path" do
                @bag_path.should exist_on_fs
              end

              it "should have a directory data path" do
                File.join(@bag_path, '/data').should exist_on_fs
              end

              it "should have two manifest.txt files" do
                manifest_files = Dir.glob pattern
                manifest_files.count.should == 2
              end

              it "should have two tagmanifest.txt files" do
                tagmanifest_files = Dir.glob tag_pattern
                tagmanifest_files.count.should == 2
              end
            end
        end

      context "when write_bag_info is called" do

        before(:each) do
          @bag.write_bag_info({'File-System-Group' => 'Hash-Example'})
        end

        it "should not have a bagit.txt file" do
          File.join(@bag_path, 'bagit.txt').should_not exist_on_fs
        end

        it "should have a bag-info.txt file" do
          File.join(@bag_path, 'bag-info.txt').should exist_on_fs
        end

        it "should have a directory bag path" do
          @bag_path.should exist_on_fs
        end

        it "should not have a directory data path" do
          File.join(@bag_path, '/data').should_not exist_on_fs
        end

        it "should not have any manifest.txt files" do
          manifest_files = Dir.glob pattern
          manifest_files.count.should == 0
        end

        it "should not have any tagmanifest.txt files" do
          tagmanifest_files = Dir.glob tag_pattern
          tagmanifest_files.count.should == 0
        end
      end

      context "when add_tag_file is called" do

        before(:each) do
          @bag.add_tag_file('tag_file_1') { |f| f.puts "I am entering a tag file" }
        end

        it "should have a bagit.txt file" do
          File.join(@bag_path, 'bagit.txt').should exist_on_fs
        end

        it "should have a bag-info.txt file" do
          File.join(@bag_path, 'bag-info.txt').should exist_on_fs
        end

        it "should have a directory bag path" do
          @bag_path.should exist_on_fs
        end

        it "should have a directory data path" do
          File.join(@bag_path, '/data').should exist_on_fs
        end

        it "should not have any manifest.txt files" do
          manifest_files = Dir.glob pattern
          manifest_files.count.should == 0
        end

        it "should have two tagmanifest.txt files" do
          tagmanifest_files = Dir.glob tag_pattern
          tagmanifest_files.count.should == 2
        end
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

      it "should have a directory bag path" do
        @bag_path.should exist_on_fs
      end

      it "should not have a directory data path" do
        File.join(@bag_path, '/data').should_not exist_on_fs
      end

      it "should not have any manifest.txt files" do
        manifest_files = Dir.glob pattern
        manifest_files.count.should == 0
      end

      it "should not have any tagmanifest.txt files" do
        tagmanifest_files = Dir.glob tag_pattern
        tagmanifest_files.count.should == 0
      end
    end
  end

  context "when the directory exists" do

    before(:each) do

      @sandbox = Sandbox.new

      # make the bag
      @bag_path = File.join @sandbox.to_s, 'the_bag'
      @bag = BagIt::Bag.new @bag_path
      @bag.add_file('newfile.txt') { |io| io.puts("new file to bag data path") }

      @bag_path = File.join @sandbox.to_s, 'the_bag'
      @bag = BagIt::Bag.new @bag_path
    end

    after(:each) do
      @sandbox.cleanup!
    end

    it "should have a bagit.txt file" do
      File.join(@bag_path, 'bagit.txt').should exist_on_fs
    end

    it "should have a bag-info.txt file" do
      File.join(@bag_path, 'bag-info.txt').should exist_on_fs
    end

    it "should have a directory bag path" do
      @bag_path.should exist_on_fs
    end

    it "should have a directory data path" do
      File.join(@bag_path, '/data').should exist_on_fs
    end

    it "should not have any manifest.txt files" do
      manifest_files = Dir.glob pattern
      manifest_files.count.should == 0
    end

    it "should not have any tagmanifest.txt files" do
      tagmanifest_files = Dir.glob tag_pattern
      tagmanifest_files.count.should == 0
    end

      context "when manifest! is called on the bag" do

        before(:each) do
          @bag.manifest!
        end

        it "should have a bagit.txt file" do
          File.join(@bag_path, 'bagit.txt').should exist_on_fs
        end

        it "should have a bag-info.txt file" do
          File.join(@bag_path, 'bag-info.txt').should exist_on_fs
        end

        it "should have a directory bag path" do
          @bag_path.should exist_on_fs
        end

        it "should have a directory data path" do
          File.join(@bag_path, '/data').should exist_on_fs
        end

        it "should have two manifest.txt files" do
          manifest_files = Dir.glob pattern
          manifest_files.count.should == 2
        end

        it "should have two tagmanifest.txt files" do
          tagmanifest_files = Dir.glob tag_pattern
          tagmanifest_files.count.should == 2
        end
      end
  end
end
