enum Collection {
  BASE_USERS,
  EXPERTS,
  REPORTS,
  MESSAGES,
  UTILS,
  ACTIVE_CHATS,
  PENDING_CHATS,
  REQUESTS_CHATS,
  EXPERT_CHATS,
  DIARY
}

extension Utils on Collection {
  String get value {
    switch (this) {
      case Collection.BASE_USERS:
        return 'users';
        break;
      case Collection.EXPERTS:
        return 'experts';
        break;
      case Collection.REPORTS:
        return 'reports';
        break;
      case Collection.MESSAGES:
        return 'messages';
        break;
      case Collection.UTILS:
        return 'utils';
        break;
      case Collection.ACTIVE_CHATS:
        return 'anonymousActiveChats';
        break;
      case Collection.PENDING_CHATS:
        return 'anonymousPendingChats';
        break;
      case Collection.REQUESTS_CHATS:
        return 'anonymousRequestChats';
        break;
      case Collection.EXPERT_CHATS:
        return 'expertChats';
        break;
      case Collection.DIARY:
        return 'diary';
        break;
      default:
        return '';
        break;
    }
  }
}
