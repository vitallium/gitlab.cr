module Gitlab
  class Client
    # Defines methods related to tag.
    #
    # See [http://docs.gitlab.com/ce/api/tags.html](http://docs.gitlab.com/ce/api/tags.html)
    module Tag
      # Gets a list of tags in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of tags under a project.
      #
      # ```
      # client.tags(1)
      # client.v(1, { "per_page" => "10" })
      # ```
      def tags(project_id : Int32, params : Hash? = nil)
        get("/projects/#{project_id}/repository/tags", params).body.parse_json
      end

      # Get single tag in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] tag The name of a tag.
      # - return [Hash] Information about the tag in a project.
      #
      # ```
      # client.tag(1, "master")
      # ```
      def tag(project_id : Int32, tag : String)
        get("/projects/#{project_id}/repository/tags/#{tag}").body.parse_json
      end

      # Create a tag in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] tag The name of a tag.
      # - param  [String] ref Create tag using commit SHA, another tag name, or branch name.
      # - param  [String] params A customizable set of the params.
      # - option params  [String] :message Creates annotated tag.
      # - param  params [String] :release_description Add release notes to the git tag and store it in the GitLab database.
      # - return [Hash] Information about the created tag in a project.
      #
      # ```
      # client.create_tag(1, "1.0.0", "master")
      # client.create_tag(1, "1.0.1", "1.0.0", { "message" => "message in tag", "release_description" => "message in gitlab" })
      # ```
      def create_tag(project_id : Int32, tag : String, ref : String, params : Hash = {} of String => String)
        post("/projects/#{project_id}/repository/tags", {
          "tag_name" => tag,
          "ref" => ref
        }.merge(params)).body.parse_json
      end

      # Delete a tag.
      #
      # - param  [Int32] group_id The ID of a group
      # - param  [String] tag The name of a tag.
      # - return [Hash] Information about the deleted tag.
      #
      # ```
      # client.delete_tag(42)
      # ```
      def delete_tag(project_id : Int32, tag : String)
        delete("/projects/#{project_id}/repository/tag/#{tag}").body.parse_json
      end

      # Create release notes in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] tag The name of a tag.
      # - param  [String] description Release notes with markdown support.
      # - return [Hash] Information about the created release notes in a project.
      #
      # ```
      # client.create_release_notes(1, "1.0.0", "Release v1.0.0")
      # ```
      def create_release_notes(project_id : Int32, tag : String, description : String)
        post("/projects/#{project_id}/repository/tags/#{tag}/release", {
          "description" => description,
        }).body.parse_json
      end

      # Update release notes in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] tag The name of a tag.
      # - param  [String] description Release notes with markdown support.
      # - return [Hash] Information about the updated release notes in a project.
      #
      # ```
      # client.create_release_notes(1, "1.0.0", "# Release v1.0.0\n## xxx\n## xxx")
      # ```
      def update_release_notes(project_id : Int32, tag : String, description : String)
        put("/projects/#{project_id}/repository/tags/#{tag}/release", {
          "description" => description,
        }).body.parse_json
      end
    end
  end
end