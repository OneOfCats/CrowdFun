module CommentsHelper
	def path_to_commentable commentable
		resources = commentable
		resources = [commentable.parent, commentable] if commentable.respond_to?(:parent)
		polymorphic_path resources
	end
end
