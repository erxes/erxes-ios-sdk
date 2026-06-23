import Foundation

/// Single source of truth for every GraphQL operation the SDK sends.
///
/// These strings were previously inlined inside each view model, which meant the
/// shared selection sets (a message's `user`/`attachments` blocks especially) were
/// copy-pasted across `fetch`, `insert`, and `subscription` operations and had to be
/// kept in sync by hand. Centralizing them here keeps the field sets in one place;
/// the small reusable selections are factored into `Fragments` and interpolated in.
///
/// GraphQL is whitespace-insensitive, so the fragment indentation does not need to
/// line up with the surrounding query — only the field names matter.
enum MessengerGraphQL {

    // MARK: - Reusable selections

    enum Fragments {
        /// Minimal author block shared by every message-bearing operation.
        static let userBrief = """
        _id
        details { avatar fullName }
        """

        /// Full attachment selection used by insert / subscription / conversation list.
        static let attachmentFields = """
        url
        name
        size
        type
        """
    }

    // MARK: - Connect / identity

    /// Initial handshake. Also re-run by identify() after a contact is captured.
    static let connect = """
    mutation connect($integrationId: String!, $visitorId: String, $cachedCustomerId: String, $email: String, $phone: String, $data: JSON) {
      widgetsMessengerConnect(integrationId: $integrationId, visitorId: $visitorId, cachedCustomerId: $cachedCustomerId, email: $email, phone: $phone, data: $data) {
        integrationId
        customerId
        visitorId
        languageCode
        uiOptions
        messengerData
        ticketConfig
      }
    }
    """

    /// Edits the connect-created customer with the requireAuth contact details.
    /// The returned `_id` becomes the cachedCustomerId passed to the next connect.
    static let customersEdit = """
    mutation CustomersEdit($customerId: String!, $firstName: String, $lastName: String, $emails: [String], $phones: [String]) {
      widgetsTicketCustomersEdit(customerId: $customerId, firstName: $firstName, lastName: $lastName, emails: $emails, phones: $phones) {
        _id
        email
        emails
        firstName
        lastName
        phone
        phones
        primaryEmail
        primaryPhone
      }
    }
    """

    static let supporters = """
    query widgetsMessengerSupporters($integrationId: String!) {
      widgetsMessengerSupporters(integrationId: $integrationId) {
        supporters {
          _id
          details { avatar fullName }
          isOnline
        }
        isOnline
      }
    }
    """

    static let saveBrowserInfo = """
    mutation saveBrowserInfo($customerId: String, $visitorId: String, $browserInfo: JSON!) {
      widgetsSaveBrowserInfo(customerId: $customerId, visitorId: $visitorId, browserInfo: $browserInfo) {
        _id content createdAt
      }
    }
    """

    // MARK: - Conversations

    static let conversations = """
    query widgetsConversations($integrationId: String!, $customerId: String, $visitorId: String) {
      widgetsConversations(
        integrationId: $integrationId
        customerId: $customerId
        visitorId: $visitorId
      ) {
        _id
        content
        createdAt
        idleTime
        participatedUsers {
          _id
          details { avatar fullName shortName }
          isOnline
        }
        messages {
          _id
          createdAt
          content
          fromBot
          customerId
          isCustomerRead
          userId
          attachments { \(Fragments.attachmentFields) }
          user {
            _id
            isOnline
            details { avatar fullName shortName }
          }
        }
      }
    }
    """

    static let conversationDetail = """
    query WidgetsConversationDetail($_id: String, $integrationId: String!) {
      widgetsConversationDetail(_id: $_id, integrationId: $integrationId) {
        _id
        messages {
          _id
          conversationId
          customerId
          attachments { name url }
          user { \(Fragments.userBrief) }
          content
          createdAt
          fromBot
          contentType
          internal
        }
      }
    }
    """

    static let insertMessage = """
    mutation WidgetsInsertMessage(
      $integrationId: String!
      $customerId: String
      $visitorId: String
      $conversationId: String
      $contentType: String
      $message: String
      $attachments: [AttachmentInput]
    ) {
      widgetsInsertMessage(
        integrationId: $integrationId
        customerId: $customerId
        visitorId: $visitorId
        conversationId: $conversationId
        contentType: $contentType
        message: $message
        attachments: $attachments
      ) {
        _id
        conversationId
        customerId
        user { \(Fragments.userBrief) }
        content
        createdAt
        fromBot
        contentType
        attachments { \(Fragments.attachmentFields) }
      }
    }
    """

    static let readConversationMessages = """
    mutation WidgetsReadConversationMessages($conversationId: String) {
      widgetsReadConversationMessages(conversationId: $conversationId)
    }
    """

    static let conversationMessageInserted = """
    subscription ConversationMessageInserted($_id: String!) {
      conversationMessageInserted(_id: $_id) {
        _id
        content
        createdAt
        customerId
        userId
        isCustomerRead
        fromBot
        user { \(Fragments.userBrief) }
        attachments { \(Fragments.attachmentFields) }
      }
    }
    """

    // MARK: - Tickets

    static let ticketsByCustomer = """
    query WidgetTicketsByCustomer($customerId: String) {
      widgetTicketsByCustomer(customerId: $customerId) {
        _id
        name
        description
        pipelineId
        statusId
        priority
        labelIds
        tagIds
        number
        startDate
        targetDate
        createdAt
        updatedAt
        status {
          _id
          color
          name
          description
          type
        }
        assignee {
          _id
          details {
            avatar
            firstName
            lastName
            fullName
          }
        }
      }
    }
    """

    static let ticketTags = """
    query WidgetsGetTicketTags($configId: String, $parentId: String) {
      widgetsGetTicketTags(configId: $configId, parentId: $parentId) {
        _id
        name
        type
        description
      }
    }
    """

    static let createTicket = """
    mutation WidgetTicketCreated(
      $name: String!
      $statusId: String!
      $customerIds: [String!]!
      $description: String
      $attachments: [AttachmentInput]
      $tagIds: [String!]
    ) {
      widgetTicketCreated(
        name: $name
        statusId: $statusId
        customerIds: $customerIds
        description: $description
        attachments: $attachments
        tagIds: $tagIds
      ) {
        _id
        number
      }
    }
    """

    // MARK: - Knowledge base

    static let knowledgeBaseTopicDetail = """
    query cpKnowledgeBaseTopicDetail($_id: String!) {
      cpKnowledgeBaseTopicDetail(_id: $_id) {
        _id
        title
        description
        color
        code
        categories {
          _id
          title
          description
          numOfArticles(status: "publish")
          countArticles
          parentCategoryId
          icon
          articles(status: "publish") {
            viewCount
            topicId
            title
            summary
            status
            publishedAt
            modifiedDate
            content
            code
            categoryId
            _id
          }
        }
        parentCategories {
          _id
          title
          description
          numOfArticles(status: "publish")
          parentCategoryId
          icon
          childrens { _id }
          articles {
            viewCount
            topicId
            title
            summary
            status
            publishedAt
            modifiedDate
            content
            code
            categoryId
            _id
          }
        }
      }
    }
    """
}
