module CommentsHelper
	def path_to_commentable commentable
		resources = [commentable]
		resources.unshift(commentable.parent_resource) if commentable.respond_to?(:parent_resource)
		polymorphic_path resources
	end
end
