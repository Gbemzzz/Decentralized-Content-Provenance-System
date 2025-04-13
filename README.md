# Decentralized Content Provenance System

A Clarity smart contract for tracking digital content ownership and provenance on the Stacks blockchain.

## Overview

This smart contract provides a decentralized solution for content creators to register their digital assets, establish verifiable ownership, and track the complete history and versioning of their content. The system enables transparent provenance tracking while giving creators control over licensing and content evolution.

## Features

- Register original digital content with immutable timestamp and creator attribution
- Update content with versioning that maintains historical links
- Manage different license types for content usage rights
- Verify the complete provenance chain of any registered content
- Track all content registered by a specific creator

## Contract Functions

### Administrative Functions

#### `register-license-type`
Registers a new license type in the system.

**Parameters:**
- `license-id`: Unique identifier for the license (string-utf8 64)
- `description`: Description of the license terms (string-utf8 512)
- `terms-url`: URL pointing to full license terms (string-utf8 256)

**Returns:** Boolean success status

**Access Control:** Only contract owner can register license types

#### `transfer-ownership`
Transfers contract ownership to a new principal.

**Parameters:**
- `new-owner`: Principal address of the new owner

**Returns:** Boolean success status

**Access Control:** Only current contract owner can transfer ownership

### Content Management Functions

#### `register-content`
Registers new digital content in the system.

**Parameters:**
- `content-hash`: Unique hash of the content (buff 32)
- `title`: Title of the content (string-utf8 256)
- `description`: Description of the content (string-utf8 1024)
- `license-type`: ID of the license type to apply (string-utf8 64)
- `previous-hash`: Optional hash of previous version (optional buff 32)

**Returns:** Boolean success status

**Validation:**
- Content hash must not already be registered
- License type must exist in the system

#### `update-content`
Creates a new version of existing content.

**Parameters:**
- `original-hash`: Hash of the original content being updated (buff 32)
- `new-hash`: Hash of the new content version (buff 32)
- `title`: Updated title (string-utf8 256)
- `description`: Updated description (string-utf8 1024)
- `license-type`: ID of the license type to apply (string-utf8 64)

**Returns:** Boolean success status

**Validation:**
- Original content must exist
- Only the original creator can update the content
- New hash must not already be registered
- License type must exist in the system

### Read-Only Functions

#### `get-content-info`
Retrieves all information about a specific content item.

**Parameters:**
- `content-hash`: Hash of the content (buff 32)

**Returns:** Content data including creator, title, timestamp, description, license type, version, and previous hash

#### `get-creator-content-list`
Retrieves a list of all content hashes registered by a specific creator.

**Parameters:**
- `creator`: Principal address of the creator

**Returns:** List of content hashes

#### `get-license-details`
Retrieves details about a specific license type.

**Parameters:**
- `license-id`: ID of the license (string-utf8 64)

**Returns:** License description and terms URL

#### `verify-provenance-chain`
Verifies and returns the complete provenance chain of a content item.

**Parameters:**
- `content-hash`: Hash of the content (buff 32)

**Returns:** List of content hashes representing the version history, from newest to oldest

## Error Codes

- `ERR-NOT-AUTHORIZED (u1)`: Caller is not authorized to perform the action
- `ERR-ALREADY-REGISTERED (u2)`: Content hash is already registered
- `ERR-NOT-FOUND (u3)`: Referenced content does not exist
- `ERR-LICENSE-NOT-FOUND (u4)`: Referenced license type does not exist

## Data Structures

### Content Registry
Maps content hashes to their metadata:
- `creator`: Principal address of the content creator
- `title`: Title of the content
- `timestamp`: Block timestamp when content was registered
- `description`: Description of the content
- `license-type`: Type of license applied to the content
- `version`: Version number of the content
- `previous-hash`: Hash of the previous version (if any)

### Creator Contents
Maps creator principals to lists of their content hashes:
- `creator`: Principal address of the creator
- `content-list`: List of content hashes registered by the creator

### License Types
Maps license IDs to their details:
- `license-id`: Unique identifier for the license
- `description`: Description of the license terms
- `terms-url`: URL pointing to full license terms

## Usage Examples

### Registering New Content
```clarity
(contract-call? .content-provenance register-content 
  0x1a2b3c4d5e6f... 
  "Digital Artwork: Sunset" 
  "A digital painting depicting a sunset over mountains" 
  "cc-by-4.0" 
  none)
```

### Updating Content
```clarity
(contract-call? .content-provenance update-content 
  0x1a2b3c4d5e6f... 
  0xf6e5d4c3b2a1... 
  "Digital Artwork: Sunset (Enhanced)" 
  "An enhanced version with improved colors and details" 
  "cc-by-4.0")
```

### Verifying Content Provenance
```clarity
(contract-call? .content-provenance verify-provenance-chain 0xf6e5d4c3b2a1...)
```

## Integration Guide

This contract serves as the foundation for decentralized content provenance and can be integrated with other components to build a complete ecosystem:

1. **Front-end Application**: Build a user-friendly interface for content registration and verification
2. **Content Hashing Service**: Implement consistent content hashing to generate unique identifiers
3. **Royalty Distribution**: Add functionalities to distribute royalties based on content usage
4. **Marketplace Integration**: Enable content trading with verified provenance
5. **Analytics Dashboard**: Track content usage and licensing across the ecosystem

## Security Considerations

- Content hashes should be generated deterministically and uniquely
- Front-end applications should verify content ownership before submission
- Sensitive metadata should be stored off-chain with only hash references on-chain
- Consider implementing content takedown mechanisms for illegal content

## License

This contract is provided under [LICENSE TYPE]. See LICENSE file for details.
