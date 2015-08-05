class UserHelper

  @currentUser: (message) ->
    "@#{message.message.user.name}"

module.exports = UserHelper
