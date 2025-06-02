---
title: Onchain Notifications Guide
nextjs:
  metadata:
    title: Onchain Notifications Guide
    description: Learn how to implement onchain notifications in your Internet Computer applications to enhance user experience.
---

# Onchain Notifications

Onchain notifications are a crucial feature for modern decentralized applications, enabling real-time communication with users about important events happening on the blockchain. By implementing notifications, you can significantly improve user engagement and provide a better user experience.

## Notification Canister ID

The notification canister is deployed at: `britu-mqaaa-aaaam-aeknq-cai`

Use this canister ID when integrating onchain notifications into your Internet Computer applications.

## Why Onchain Notifications Matter

- **Real-time Updates**: Keep users informed about important events like transactions, state changes, or system updates
- **Enhanced User Experience**: Users don't need to constantly check the application for updates
- **Increased Engagement**: Timely notifications can drive user interaction and retention
- **Trust Building**: Transparent communication about onchain activities builds user trust

## Implementation Guide

### Sending Notifications

To send notifications from your canister, you'll need to use the `send_notification` method. This method requires:
1. A `NotifyMessage` structure containing the notification content
2. A recipient Principal who has:
   - Registered their device tokens with the notification canister
   - Granted permission to your canister to send them notifications

Each notification costs approximately 50 million cycles. For better performance, you can use the one-way notification method which costs 1 billion cycles but doesn't wait for a response.

Here's how to implement it in your Rust canister:

```rust
use candid::{CandidType, Deserialize};
use ic_cdk::api::call::CallResult;

#[derive(Clone, Debug, CandidType, Deserialize)]
struct NotifyMessage {
    title: String,
    body: String,
    action_url: Option<String>,
    icon_url: Option<String>,
    data_type: Option<String>,
}

// Example implementation in your canister
#[update]
async fn notify_user(recipient: Principal, message: NotifyMessage) -> CallResult<()> {
    let notification_canister_id = Principal::from_text("britu-mqaaa-aaaam-aeknq-cai").unwrap();
    
    ic_cdk::call::<_, (Result<(), String>,)>(
        notification_canister_id,
        "send_notification",
        (message, recipient)
    ).await.map(|(result,)| result)
}

// High-performance one-way notification
#[update]
fn notify_user_fast(recipient: Principal, message: NotifyMessage) {
    let notification_canister_id = Principal::from_text("britu-mqaaa-aaaam-aeknq-cai").unwrap();
    
    // Send one-way notification with 1 billion cycles
    let _ = ic_cdk::notify_with_payment128(
        notification_canister_id,
        "send_notification",
        (message, recipient),
        1_000_000_000 // 1 billion cycles
    );
}
```

### Best Practices

1. **Use One-Way Notifications for Better Performance**: When you don't need to wait for the notification result, use `notify_with_payment128`:

```rust
#[update]
async fn process_transaction(/* your params */) -> Result<(), String> {
    // Process your transaction
    let result = process_your_transaction().await?;
    
    // Send notification asynchronously using one-way call
    let message = NotifyMessage {
        title: "Transaction Complete".to_string(),
        body: "Your transaction has been processed successfully".to_string(),
        action_url: Some("https://your-app.com/transactions".to_string()),
        icon_url: None,
        data_type: Some("transaction".to_string()),
    };
    
    // Use one-way notification for better performance
    notify_user_fast(recipient_principal, message);
    
    Ok(result)
}
```

2. **Error Handling**: Since notifications are non-critical, handle errors gracefully:

```rust
async fn send_notification_safely(recipient: Principal, message: NotifyMessage) {
    match notify_user(recipient, message).await {
        Ok(_) => ic_cdk::println!("Notification sent successfully"),
        Err(e) => ic_cdk::println!("Failed to send notification: {}", e),
    }
}
```

### Message Structure

The `NotifyMessage` structure supports the following fields:

- `title`: The notification title (required)
- `body`: The notification message body (required)
- `action_url`: Optional URL that opens when the notification is clicked
- `icon_url`: Optional URL for a custom notification icon
- `data_type`: Optional string to categorize the notification type

### Cycle Management

- Regular notifications cost approximately 50 million cycles
- One-way notifications using `notify_with_payment128` cost 1 billion cycles
- Ensure your canister has sufficient cycles for notification operations
- Consider implementing a cycle management strategy for high-volume applications

## Example Use Cases

1. **Transaction Notifications**:
```rust
async fn notify_transaction_complete(recipient: Principal, amount: u64, token: String) {
    let message = NotifyMessage {
        title: "Transaction Complete".to_string(),
        body: format!("You received {} {}", amount, token),
        action_url: Some("https://your-app.com/transactions".to_string()),
        icon_url: None,
        data_type: Some("transaction".to_string()),
    };
    
    // Use one-way notification for better performance
    notify_user_fast(recipient, message);
}
```

2. **System Updates**:
```rust
async fn notify_system_update(recipient: Principal, update_type: String) {
    let message = NotifyMessage {
        title: "System Update".to_string(),
        body: format!("New {} available", update_type),
        action_url: Some("https://your-app.com/updates".to_string()),
        icon_url: None,
        data_type: Some("system_update".to_string()),
    };
    
    // Use one-way notification for better performance
    notify_user_fast(recipient, message);
}
```

## Important Notes

- Always implement notifications asynchronously to avoid blocking your main application flow
- Use `notify_with_payment128` for better performance when you don't need to wait for the result
- Handle notification failures gracefully as they are non-critical operations
- Monitor your canister's cycle balance to ensure continuous notification service
- Consider implementing retry logic for critical notifications
- Test notifications thoroughly in your development environment before deploying to production
- The recipient must have registered their device tokens with the notification canister before they can receive notifications
- Your canister must have permission to send notifications to the recipient (see permission management section)

Remember that while notifications enhance user experience, they should be used judiciously to avoid overwhelming users with too many messages.
