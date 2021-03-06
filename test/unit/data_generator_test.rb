require File.dirname(__FILE__) + '/../test_helper'

class DataGeneratorTest < Test::Unit::TestCase
  setup {
    User.destroy_all
  }
  
  context "#all" do
    should "run users"
    should "run projects"
    should "run issues"
    should "run journals"
    should "run time_entries"
  end

  context "#users" do
    should "generate 5 random users by default" do
      assert_difference("User.count",5) do
        DataGenerator.users
      end
    end

    should "generate x random users with a parameter" do
      assert_difference("User.count", 50) do
        DataGenerator.users 50
      end
    end
  end

  context "#projects" do
    should "generate 5 random projects by default" do
      assert_difference("Project.count",5) do
        DataGenerator.projects
      end
    end

    should "generate x random projects with a parameter" do
      assert_difference("Project.count",50) do
        DataGenerator.projects 50
      end
    end

    should "assign all users to the project" do
      5.times { User.make }

      assert_difference("Member.count", 25) do
        DataGenerator.projects
      end

      Project.all.each do |project|
        assert_equal 5, project.members.length
      end
    end

    should "enable all modules for each project" do
      module_count = Redmine::AccessControl.available_project_modules.length
      
      DataGenerator.projects

      Project.all.each do |project|
        assert_equal module_count, project.enabled_modules.length
      end

    end
    
  end

  context "#issues" do
    setup {
      5.times { make_project_with_trackers }
      5.times { IssuePriority.make }
      5.times { User.make }
    }
    
    should "generate 100 random issues by default" do
      assert_difference("Issue.count",100) do
        DataGenerator.issues
      end
    end

    should "generate x random issues with a parameter" do
      assert_difference("Issue.count",500) do
        DataGenerator.issues 500
      end
    end
  end

  context "#journals" do
    should "generate 100 random journal entries by default"
    should "generate x random journal entries with a parameter"
  end

  context "#time_entries" do
    setup {
      5.times { make_project_with_trackers }
      project = Project.find(:last)
      5.times {
        Issue.make(:project => project, :tracker => project.trackers.last)
      }
      5.times { User.make }
      5.times { TimeEntryActivity.make }
    }

    should "generate 100 random time entries by default" do
      assert_difference("TimeEntry.count", 100) do
        DataGenerator.time_entries
      end
    end

    should "generate x random time entries with a parameter" do
      assert_difference("TimeEntry.count", 250) do
        DataGenerator.time_entries 250
      end
    end
  end
end
