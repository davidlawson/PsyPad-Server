class SharedResourcesAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)

    # we're only worried about specific instances
    return true if subject === Class

    # admins can do anything
    return true if user.admin?

    if subject.class == User && subject == user
      return true
    end

    if subject.class == User || subject == User
      return user.admin?
    end

    # the first user holds shared image sets and gallery configurations
    shared_user = User.first

    # todo do we need ParticipantConfigurations here as well?

    # hidden
    if action == :read

      case subject
        when GalleryConfiguration
          return subject.user == shared_user ||
                 subject.user == user
        when ImageSet
          return subject.user == shared_user ||
                 subject.user == user
        when ImageGroup
          return subject.image_set.user == shared_user ||
                 subject.image_set.user == user
        when Image
          return subject.image_group.image_set.user == shared_user ||
                 subject.image_group.image_set.user == user
        when ImageFrame
          return subject.image.image_group.image_set.user == shared_user ||
                 subject.image.image_group.image_set.user == user
      end

    # read only
    elsif action == :update || action == :destroy

      case subject
        when GalleryConfiguration
          return subject.user == user
        when ImageSet
          return subject.user == user
        when ImageGroup
          return subject.image_set.user == user
        when Image
          return subject.image_group.image_set.user == user
        when ImageFrame
          return subject.image.image_group.image_set.user == user
      end

    end

    true

  end

end
