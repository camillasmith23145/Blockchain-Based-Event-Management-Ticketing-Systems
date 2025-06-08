# Blockchain-Based Event Management Ticketing System

A comprehensive decentralized ticketing system built on the Stacks blockchain using Clarity smart contracts. This system provides secure, transparent, and fraud-resistant event ticketing with built-in organizer verification, ticket transfers, access control, and fraud prevention mechanisms.

## 🎯 Features

### Core Functionality
- **Event Organizer Verification**: Validates and manages event organizers with reputation scoring
- **Ticket Issuance**: Secure ticket creation and purchase system
- **Transfer Management**: Controlled ticket transfers between users
- **Access Control**: Event access validation and ticket verification
- **Fraud Prevention**: Advanced security measures to prevent ticket fraud

### Key Benefits
- **Transparency**: All transactions recorded on blockchain
- **Security**: Cryptographic verification of tickets
- **Anti-Fraud**: Built-in fraud detection and prevention
- **Decentralized**: No single point of failure
- **Immutable**: Tamper-proof ticket records

## 🏗️ Architecture

The system consists of five interconnected smart contracts:

### 1. Event Organizer Verification Contract
\`\`\`
contracts/event-organizer-verification.clar
\`\`\`
- Manages organizer registration and verification
- Tracks reputation scores
- Validates organizer credentials

### 2. Ticket Issuance Contract
\`\`\`
contracts/ticket-issuance.clar
\`\`\`
- Creates and manages events
- Issues tickets to buyers
- Tracks ticket sales and availability

### 3. Transfer Management Contract
\`\`\`
contracts/transfer-management.clar
\`\`\`
- Handles ticket transfers between users
- Manages transfer approvals and fees
- Maintains transfer history

### 4. Access Control Contract
\`\`\`
contracts/access-control.clar
\`\`\`
- Validates event access
- Manages event validators
- Logs access attempts

### 5. Fraud Prevention Contract
\`\`\`
contracts/fraud-prevention.clar
\`\`\`
- Prevents fraudulent activities
- Manages user blacklists
- Generates and verifies ticket authenticity

## 🚀 Getting Started

### Prerequisites
- Stacks blockchain node
- Clarity CLI tools
- Node.js (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd blockchain-ticketing-system
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Deploy contracts to Stacks blockchain:
   \`\`\`bash
# Deploy in order due to dependencies
clarinet deploy contracts/event-organizer-verification.clar
clarinet deploy contracts/ticket-issuance.clar
clarinet deploy contracts/transfer-management.clar
clarinet deploy contracts/access-control.clar
clarinet deploy contracts/fraud-prevention.clar
\`\`\`

### Running Tests

\`\`\`bash
npm test
\`\`\`

## 📖 Usage Guide

### For Event Organizers

1. **Register as Organizer**:
   \`\`\`clarity
   (contract-call? .event-organizer-verification register-organizer "Organizer Name" "email@example.com")
   \`\`\`

2. **Create Event**:
   \`\`\`clarity
   (contract-call? .ticket-issuance create-event "Concert Name" "Venue" u1000000 u100 u50)
   \`\`\`

3. **Add Validators**:
   \`\`\`clarity
   (contract-call? .access-control add-validator u1 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
   \`\`\`

### For Ticket Buyers

1. **Purchase Ticket**:
   \`\`\`clarity
   (contract-call? .ticket-issuance purchase-ticket u1)
   \`\`\`

2. **Transfer Ticket**:
   \`\`\`clarity
   (contract-call? .transfer-management approve-transfer u1 'ST3PF13W7Z0RRM42A8VZRVFQ75SV1K26RXEP8YGKJ)
   \`\`\`

### For Event Staff

1. **Validate Ticket**:
   \`\`\`clarity
   (contract-call? .access-control validate-ticket-access u1 "Main Entrance")
   \`\`\`

## 🔒 Security Features

### Fraud Prevention
- Rate limiting on ticket purchases
- User activity monitoring
- Blacklist management
- Ticket authenticity verification

### Access Control
- Multi-level validation system
- Authorized validator management
- Access logging and audit trails

### Transfer Security
- Approval-based transfer system
- Transfer fee management
- Transfer history tracking

## 🧪 Testing

The system includes comprehensive tests for all contracts:

- **Unit Tests**: Individual contract function testing
- **Integration Tests**: Cross-contract interaction testing
- **Security Tests**: Fraud prevention and access control testing

Test files are located in the \`tests/\` directory and use Vitest for execution.

## 📊 Contract Interactions

### Data Flow
1. Organizer registers and gets verified
2. Organizer creates event with ticket parameters
3. Users purchase tickets (fraud checks applied)
4. Tickets can be transferred (if enabled)
5. Event staff validates tickets for access
6. System logs all activities for audit

### Error Handling
All contracts implement comprehensive error handling with specific error codes:
- \`u100-199\`: Organizer verification errors
- \`u200-299\`: Ticket issuance errors
- \`u300-399\`: Transfer management errors
- \`u400-499\`: Access control errors
- \`u500-599\`: Fraud prevention errors

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## 🔮 Future Enhancements

- Mobile app integration
- QR code generation for tickets
- Dynamic pricing mechanisms
- Multi-event package deals
- Integration with external payment systems
- Advanced analytics and reporting
  \`\`\`
