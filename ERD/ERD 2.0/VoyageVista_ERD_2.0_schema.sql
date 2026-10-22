-- VoyageVista ERD 2.0 - PostgreSQL schema (gegenereerd uit het datamodel)

-- ===== Algemeen (gedeeld) =====
CREATE TABLE "Address" (
    "addressID" INTEGER NOT NULL,
    "street" VARCHAR(80) NOT NULL,
    "houseNumber" VARCHAR(10) NOT NULL,
    "addressSuffix" VARCHAR(10),
    "postalCode" VARCHAR(10) NOT NULL,
    "city" VARCHAR(80) NOT NULL,
    "country" CHAR(2) NOT NULL,
    CONSTRAINT "pk_Address" PRIMARY KEY ("addressID")
);

CREATE TABLE "Department" (
    "departmentID" INTEGER NOT NULL,
    "name" VARCHAR(60) NOT NULL UNIQUE,
    CONSTRAINT "pk_Department" PRIMARY KEY ("departmentID")
);

CREATE TABLE "Employee" (
    "employeeID" INTEGER NOT NULL,
    "departmentID" INTEGER NOT NULL,
    "firstName" VARCHAR(50) NOT NULL,
    "namePrefix" VARCHAR(20),
    "lastName" VARCHAR(80) NOT NULL,
    "email" VARCHAR(254) NOT NULL UNIQUE,
    "active" BOOLEAN NOT NULL,
    CONSTRAINT "pk_Employee" PRIMARY KEY ("employeeID")
);

CREATE TABLE "Customer" (
    "customerID" INTEGER NOT NULL,
    "addressID" INTEGER,
    "firstName" VARCHAR(50) NOT NULL,
    "namePrefix" VARCHAR(20),
    "lastName" VARCHAR(80) NOT NULL,
    "birthDate" DATE,
    "email" VARCHAR(254) NOT NULL UNIQUE,
    "phone" VARCHAR(25),
    "marketingConsent" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_Customer" PRIMARY KEY ("customerID")
);

CREATE TABLE "CommunicationChannel" (
    "channelID" INTEGER NOT NULL,
    "name" VARCHAR(40) NOT NULL UNIQUE,
    CONSTRAINT "pk_CommunicationChannel" PRIMARY KEY ("channelID")
);

CREATE TABLE "Notification" (
    "notificationID" INTEGER NOT NULL,
    "customerID" INTEGER,
    "employeeID" INTEGER,
    "bookingID" INTEGER,
    "channelID" INTEGER NOT NULL,
    "type" VARCHAR(30) NOT NULL,
    "subject" VARCHAR(120) NOT NULL,
    "message" VARCHAR(500) NOT NULL,
    "createdAt" TIMESTAMP NOT NULL,
    "readAt" TIMESTAMP,
    CONSTRAINT "pk_Notification" PRIMARY KEY ("notificationID")
);

-- ===== Marketing & Communicatie =====
CREATE TABLE "CustomerPreference" (
    "preferenceID" INTEGER NOT NULL,
    "customerID" INTEGER NOT NULL,
    "category" VARCHAR(50) NOT NULL,
    "value" VARCHAR(120) NOT NULL,
    "priority" SMALLINT,
    "updatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_CustomerPreference" PRIMARY KEY ("preferenceID")
);

CREATE TABLE "CustomerSegment" (
    "segmentID" INTEGER NOT NULL,
    "name" VARCHAR(80) NOT NULL UNIQUE,
    "description" VARCHAR(300),
    "active" BOOLEAN NOT NULL,
    CONSTRAINT "pk_CustomerSegment" PRIMARY KEY ("segmentID")
);

CREATE TABLE "CustomerSegmentMember" (
    "customerID" INTEGER NOT NULL,
    "segmentID" INTEGER NOT NULL,
    "addedAt" DATE NOT NULL,
    CONSTRAINT "pk_CustomerSegmentMember" PRIMARY KEY ("customerID", "segmentID")
);

CREATE TABLE "Campaign" (
    "campaignID" INTEGER NOT NULL,
    "employeeID" INTEGER NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "startDate" DATE NOT NULL,
    "endDate" DATE,
    "status" VARCHAR(30) NOT NULL,
    "budget" NUMERIC(12,2),
    CONSTRAINT "pk_Campaign" PRIMARY KEY ("campaignID")
);

CREATE TABLE "CampaignSegment" (
    "campaignID" INTEGER NOT NULL,
    "segmentID" INTEGER NOT NULL,
    CONSTRAINT "pk_CampaignSegment" PRIMARY KEY ("campaignID", "segmentID")
);

CREATE TABLE "CampaignChannel" (
    "campaignID" INTEGER NOT NULL,
    "channelID" INTEGER NOT NULL,
    CONSTRAINT "pk_CampaignChannel" PRIMARY KEY ("campaignID", "channelID")
);

CREATE TABLE "CampaignTravelProduct" (
    "campaignID" INTEGER NOT NULL,
    "travelProductID" INTEGER NOT NULL,
    CONSTRAINT "pk_CampaignTravelProduct" PRIMARY KEY ("campaignID", "travelProductID")
);

CREATE TABLE "CampaignResult" (
    "resultID" INTEGER NOT NULL,
    "campaignID" INTEGER NOT NULL,
    "channelID" INTEGER,
    "measurementDate" DATE NOT NULL,
    "impressions" INTEGER NOT NULL,
    "clicks" INTEGER NOT NULL,
    "inquiries" INTEGER NOT NULL,
    "bookings" INTEGER NOT NULL,
    "revenue" NUMERIC(14,2) NOT NULL,
    CONSTRAINT "pk_CampaignResult" PRIMARY KEY ("resultID")
);

CREATE TABLE "Promotion" (
    "promotionID" INTEGER NOT NULL,
    "campaignID" INTEGER NOT NULL,
    "promoCode" VARCHAR(30) UNIQUE,
    "description" VARCHAR(255) NOT NULL,
    "discountPct" NUMERIC(5,2),
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    CONSTRAINT "pk_Promotion" PRIMARY KEY ("promotionID")
);

CREATE TABLE "PromotionTravelProduct" (
    "promotionID" INTEGER NOT NULL,
    "travelProductID" INTEGER NOT NULL,
    "promotionalPrice" NUMERIC(12,2) NOT NULL,
    CONSTRAINT "pk_PromotionTravelProduct" PRIMARY KEY ("promotionID", "travelProductID")
);

CREATE TABLE "Content" (
    "contentID" INTEGER NOT NULL,
    "campaignID" INTEGER NOT NULL,
    "channelID" INTEGER NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "body" VARCHAR(1000) NOT NULL,
    "publicationDate" DATE,
    CONSTRAINT "pk_Content" PRIMARY KEY ("contentID")
);

-- ===== Sales & Boekingen =====
CREATE TABLE "TravelProduct" (
    "travelProductID" INTEGER NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "description" VARCHAR(500),
    "destination" VARCHAR(120) NOT NULL,
    "durationDays" SMALLINT NOT NULL,
    "salePrice" NUMERIC(12,2) NOT NULL,
    "currency" CHAR(3) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "publicationDate" DATE,
    CONSTRAINT "pk_TravelProduct" PRIMARY KEY ("travelProductID")
);

CREATE TABLE "ProductMedia" (
    "mediaID" INTEGER NOT NULL,
    "travelProductID" INTEGER NOT NULL,
    "type" VARCHAR(30) NOT NULL,
    "url" VARCHAR(500) NOT NULL,
    "altText" VARCHAR(255),
    "sequence" SMALLINT NOT NULL,
    "active" BOOLEAN NOT NULL,
    CONSTRAINT "pk_ProductMedia" PRIMARY KEY ("mediaID")
);

CREATE TABLE "Favorite" (
    "customerID" INTEGER NOT NULL,
    "travelProductID" INTEGER NOT NULL,
    "addedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_Favorite" PRIMARY KEY ("customerID", "travelProductID")
);

CREATE TABLE "Inquiry" (
    "inquiryID" INTEGER NOT NULL,
    "customerID" INTEGER NOT NULL,
    "travelProductID" INTEGER,
    "description" VARCHAR(500) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "createdAt" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_Inquiry" PRIMARY KEY ("inquiryID")
);

CREATE TABLE "Quote" (
    "quoteID" INTEGER NOT NULL,
    "customerID" INTEGER NOT NULL,
    "employeeID" INTEGER,
    "inquiryID" INTEGER,
    "travelProductID" INTEGER,
    "createdAt" TIMESTAMP NOT NULL,
    "validUntil" DATE NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "comment" VARCHAR(500),
    CONSTRAINT "pk_Quote" PRIMARY KEY ("quoteID")
);

CREATE TABLE "QuoteLine" (
    "quoteID" INTEGER NOT NULL,
    "lineNumber" SMALLINT NOT NULL,
    "offerID" INTEGER NOT NULL,
    "quantity" SMALLINT NOT NULL,
    "unitPrice" NUMERIC(12,2) NOT NULL,
    "discountPct" NUMERIC(5,2),
    CONSTRAINT "pk_QuoteLine" PRIMARY KEY ("quoteID", "lineNumber")
);

CREATE TABLE "Booking" (
    "bookingID" INTEGER NOT NULL,
    "bookingNumber" VARCHAR(20) NOT NULL UNIQUE,
    "customerID" INTEGER NOT NULL,
    "employeeID" INTEGER,
    "quoteID" INTEGER,
    "travelProductID" INTEGER,
    "promotionID" INTEGER,
    "bookingDate" TIMESTAMP NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "currency" CHAR(3) NOT NULL,
    CONSTRAINT "pk_Booking" PRIMARY KEY ("bookingID")
);

CREATE TABLE "BookingLine" (
    "bookingID" INTEGER NOT NULL,
    "lineNumber" SMALLINT NOT NULL,
    "offerID" INTEGER NOT NULL,
    "quantity" SMALLINT NOT NULL,
    "unitPrice" NUMERIC(12,2) NOT NULL,
    "discountPct" NUMERIC(5,2),
    CONSTRAINT "pk_BookingLine" PRIMARY KEY ("bookingID", "lineNumber")
);

CREATE TABLE "Cancellation" (
    "cancellationID" INTEGER NOT NULL,
    "bookingID" INTEGER NOT NULL,
    "cancellationDate" DATE NOT NULL,
    "reason" VARCHAR(255) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "refundAmount" NUMERIC(12,2) NOT NULL,
    CONSTRAINT "pk_Cancellation" PRIMARY KEY ("cancellationID")
);

-- ===== Klantenservice & Support =====
CREATE TABLE "ServiceTicket" (
    "ticketID" INTEGER NOT NULL,
    "customerID" INTEGER NOT NULL,
    "bookingID" INTEGER,
    "employeeID" INTEGER,
    "channelID" INTEGER NOT NULL,
    "type" VARCHAR(20) NOT NULL,
    "subject" VARCHAR(150) NOT NULL,
    "description" VARCHAR(1000) NOT NULL,
    "priority" VARCHAR(20) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "createdAt" TIMESTAMP NOT NULL,
    "closedAt" TIMESTAMP,
    "slaDeadline" TIMESTAMP,
    CONSTRAINT "pk_ServiceTicket" PRIMARY KEY ("ticketID")
);

CREATE TABLE "TicketStatusHistory" (
    "statusHistoryID" INTEGER NOT NULL,
    "ticketID" INTEGER NOT NULL,
    "employeeID" INTEGER,
    "status" VARCHAR(30) NOT NULL,
    "changedAt" TIMESTAMP NOT NULL,
    "explanation" VARCHAR(500),
    CONSTRAINT "pk_TicketStatusHistory" PRIMARY KEY ("statusHistoryID")
);

CREATE TABLE "CustomerContact" (
    "contactID" INTEGER NOT NULL,
    "customerID" INTEGER NOT NULL,
    "channelID" INTEGER NOT NULL,
    "employeeID" INTEGER,
    "ticketID" INTEGER,
    "contactDate" TIMESTAMP NOT NULL,
    "direction" VARCHAR(15) NOT NULL,
    "summary" VARCHAR(1000) NOT NULL,
    CONSTRAINT "pk_CustomerContact" PRIMARY KEY ("contactID")
);

CREATE TABLE "CustomerFeedback" (
    "feedbackID" INTEGER NOT NULL,
    "customerID" INTEGER NOT NULL,
    "bookingID" INTEGER,
    "ticketID" INTEGER,
    "score" SMALLINT NOT NULL,
    "comment" VARCHAR(1000),
    "feedbackDate" DATE NOT NULL,
    CONSTRAINT "pk_CustomerFeedback" PRIMARY KEY ("feedbackID")
);

-- ===== Productontwikkeling & Inkoop =====
CREATE TABLE "Supplier" (
    "supplierID" INTEGER NOT NULL,
    "addressID" INTEGER,
    "name" VARCHAR(120) NOT NULL,
    "type" VARCHAR(50) NOT NULL,
    "email" VARCHAR(254),
    "phone" VARCHAR(25),
    "active" BOOLEAN NOT NULL,
    "lastModified" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_Supplier" PRIMARY KEY ("supplierID")
);

CREATE TABLE "Negotiation" (
    "negotiationID" INTEGER NOT NULL,
    "supplierID" INTEGER NOT NULL,
    "employeeID" INTEGER NOT NULL,
    "subject" VARCHAR(150) NOT NULL,
    "startDate" DATE NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "result" VARCHAR(500),
    "priority" VARCHAR(20) NOT NULL,
    "lastUpdated" TIMESTAMP NOT NULL,
    "remarks" VARCHAR(500),
    CONSTRAINT "pk_Negotiation" PRIMARY KEY ("negotiationID")
);

CREATE TABLE "Contract" (
    "contractID" INTEGER NOT NULL,
    "supplierID" INTEGER NOT NULL,
    "negotiationID" INTEGER,
    "contractNumber" VARCHAR(60) NOT NULL UNIQUE,
    "startDate" DATE NOT NULL,
    "endDate" DATE,
    "status" VARCHAR(30) NOT NULL,
    "terms" VARCHAR(1000),
    "contractValue" NUMERIC(12,2),
    CONSTRAINT "pk_Contract" PRIMARY KEY ("contractID")
);

CREATE TABLE "TravelComponent" (
    "travelComponentID" INTEGER NOT NULL,
    "type" VARCHAR(30) NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "description" VARCHAR(500),
    "status" VARCHAR(30) NOT NULL,
    "lastModified" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_TravelComponent" PRIMARY KEY ("travelComponentID")
);

CREATE TABLE "Flight" (
    "travelComponentID" INTEGER NOT NULL,
    "flightNumber" VARCHAR(15) NOT NULL,
    "airline" VARCHAR(80) NOT NULL,
    "departureAirport" CHAR(3) NOT NULL,
    "arrivalAirport" CHAR(3) NOT NULL,
    "departureTime" TIMESTAMP NOT NULL,
    "arrivalTime" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_Flight" PRIMARY KEY ("travelComponentID")
);

CREATE TABLE "Accommodation" (
    "travelComponentID" INTEGER NOT NULL,
    "addressID" INTEGER NOT NULL,
    "roomType" VARCHAR(80),
    "numberOfNights" SMALLINT,
    "stars" SMALLINT,
    CONSTRAINT "pk_Accommodation" PRIMARY KEY ("travelComponentID")
);

CREATE TABLE "Activity" (
    "travelComponentID" INTEGER NOT NULL,
    "addressID" INTEGER,
    "durationMinutes" INTEGER,
    "minimumAge" SMALLINT,
    CONSTRAINT "pk_Activity" PRIMARY KEY ("travelComponentID")
);

CREATE TABLE "ComponentOffer" (
    "offerID" INTEGER NOT NULL,
    "travelComponentID" INTEGER NOT NULL,
    "contractID" INTEGER NOT NULL,
    "price" NUMERIC(12,2) NOT NULL,
    "currency" CHAR(3) NOT NULL,
    "availableQuantity" INTEGER NOT NULL,
    "validFrom" DATE NOT NULL,
    "validUntil" DATE,
    "lastUpdated" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_ComponentOffer" PRIMARY KEY ("offerID")
);

CREATE TABLE "PriceHistory" (
    "priceHistoryID" INTEGER NOT NULL,
    "offerID" INTEGER NOT NULL,
    "price" NUMERIC(12,2) NOT NULL,
    "validFrom" DATE NOT NULL,
    "validUntil" DATE,
    "recordedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_PriceHistory" PRIMARY KEY ("priceHistoryID")
);

CREATE TABLE "TravelProductComponent" (
    "travelProductID" INTEGER NOT NULL,
    "travelComponentID" INTEGER NOT NULL,
    "sequence" SMALLINT NOT NULL,
    "defaultQuantity" SMALLINT NOT NULL,
    "included" BOOLEAN NOT NULL,
    CONSTRAINT "pk_TravelProductComponent" PRIMARY KEY ("travelProductID", "travelComponentID")
);

CREATE TABLE "DevelopmentProject" (
    "developmentProjectID" INTEGER NOT NULL,
    "employeeID" INTEGER NOT NULL,
    "travelProductID" INTEGER,
    "projectName" VARCHAR(120) NOT NULL,
    "description" VARCHAR(500),
    "startDate" DATE NOT NULL,
    "launchDeadline" DATE NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    CONSTRAINT "pk_DevelopmentProject" PRIMARY KEY ("developmentProjectID")
);

CREATE TABLE "Milestone" (
    "milestoneID" INTEGER NOT NULL,
    "developmentProjectID" INTEGER NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "description" VARCHAR(500),
    "deadline" DATE NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    CONSTRAINT "pk_Milestone" PRIMARY KEY ("milestoneID")
);

CREATE TABLE "Task" (
    "taskID" INTEGER NOT NULL,
    "developmentProjectID" INTEGER NOT NULL,
    "employeeID" INTEGER,
    "title" VARCHAR(150) NOT NULL,
    "description" VARCHAR(500),
    "deadline" DATE NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    CONSTRAINT "pk_Task" PRIMARY KEY ("taskID")
);

CREATE TABLE "ProjectTravelComponent" (
    "developmentProjectID" INTEGER NOT NULL,
    "travelComponentID" INTEGER NOT NULL,
    CONSTRAINT "pk_ProjectTravelComponent" PRIMARY KEY ("developmentProjectID", "travelComponentID")
);

CREATE TABLE "PurchaseInvoice" (
    "purchaseInvoiceID" INTEGER NOT NULL,
    "supplierID" INTEGER NOT NULL,
    "invoiceNumber" VARCHAR(50) NOT NULL,
    "invoiceDate" DATE NOT NULL,
    "dueDate" DATE NOT NULL,
    "totalAmount" NUMERIC(12,2) NOT NULL,
    "vatAmount" NUMERIC(12,2) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    CONSTRAINT "pk_PurchaseInvoice" PRIMARY KEY ("purchaseInvoiceID"),
    CONSTRAINT "uq_PurchaseInvoice" UNIQUE ("supplierID", "invoiceNumber")
);

CREATE TABLE "PurchaseInvoiceLine" (
    "purchaseInvoiceID" INTEGER NOT NULL,
    "lineNumber" SMALLINT NOT NULL,
    "offerID" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "pricePerUnit" NUMERIC(12,2) NOT NULL,
    "vatPercentage" NUMERIC(5,2) NOT NULL,
    CONSTRAINT "pk_PurchaseInvoiceLine" PRIMARY KEY ("purchaseInvoiceID", "lineNumber")
);

-- ===== Financiën & Administratie =====
CREATE TABLE "Invoice" (
    "invoiceID" INTEGER NOT NULL,
    "bookingID" INTEGER NOT NULL,
    "invoiceNumber" VARCHAR(60) NOT NULL UNIQUE,
    "invoiceDate" DATE NOT NULL,
    "dueDate" DATE NOT NULL,
    "amount" NUMERIC(12,2) NOT NULL,
    "currency" CHAR(3) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    CONSTRAINT "pk_Invoice" PRIMARY KEY ("invoiceID")
);

CREATE TABLE "PaymentMethod" (
    "paymentMethodID" INTEGER NOT NULL,
    "code" VARCHAR(20) NOT NULL UNIQUE,
    "description" VARCHAR(50) NOT NULL,
    CONSTRAINT "pk_PaymentMethod" PRIMARY KEY ("paymentMethodID")
);

CREATE TABLE "Payment" (
    "paymentID" INTEGER NOT NULL,
    "invoiceID" INTEGER NOT NULL,
    "paymentMethodID" INTEGER,
    "paidAt" TIMESTAMP NOT NULL,
    "amount" NUMERIC(12,2) NOT NULL,
    "transactionReference" VARCHAR(100) UNIQUE,
    "status" VARCHAR(30) NOT NULL,
    CONSTRAINT "pk_Payment" PRIMARY KEY ("paymentID")
);

CREATE TABLE "PaymentReminder" (
    "reminderID" INTEGER NOT NULL,
    "invoiceID" INTEGER NOT NULL,
    "channelID" INTEGER NOT NULL,
    "sentAt" TIMESTAMP NOT NULL,
    "level" SMALLINT NOT NULL,
    CONSTRAINT "pk_PaymentReminder" PRIMARY KEY ("reminderID")
);

CREATE TABLE "Refund" (
    "refundID" INTEGER NOT NULL,
    "cancellationID" INTEGER NOT NULL,
    "paymentMethodID" INTEGER NOT NULL,
    "refundDate" DATE NOT NULL,
    "amount" NUMERIC(12,2) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    CONSTRAINT "pk_Refund" PRIMARY KEY ("refundID")
);

CREATE TABLE "LedgerAccount" (
    "accountCode" VARCHAR(10) NOT NULL,
    "name" VARCHAR(80) NOT NULL,
    "accountType" VARCHAR(20) NOT NULL,
    CONSTRAINT "pk_LedgerAccount" PRIMARY KEY ("accountCode")
);

CREATE TABLE "JournalEntry" (
    "journalEntryID" INTEGER NOT NULL,
    "bookingID" INTEGER,
    "purchaseInvoiceID" INTEGER,
    "entryDate" DATE NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "fiscalYear" SMALLINT NOT NULL,
    CONSTRAINT "pk_JournalEntry" PRIMARY KEY ("journalEntryID")
);

CREATE TABLE "JournalEntryLine" (
    "journalEntryID" INTEGER NOT NULL,
    "lineNumber" SMALLINT NOT NULL,
    "accountCode" VARCHAR(10) NOT NULL,
    "description" VARCHAR(255),
    "debitAmount" NUMERIC(12,2) NOT NULL,
    "creditAmount" NUMERIC(12,2) NOT NULL,
    CONSTRAINT "pk_JournalEntryLine" PRIMARY KEY ("journalEntryID", "lineNumber")
);

-- ===== IT & Innovatie =====
CREATE TABLE "System" (
    "systemID" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL UNIQUE,
    "type" VARCHAR(50) NOT NULL,
    "vendor" VARCHAR(100),
    "version" VARCHAR(30),
    "status" VARCHAR(30) NOT NULL,
    "legacy" BOOLEAN NOT NULL,
    CONSTRAINT "pk_System" PRIMARY KEY ("systemID")
);

CREATE TABLE "Integration" (
    "integrationID" INTEGER NOT NULL,
    "sourceSystemID" INTEGER NOT NULL,
    "targetSystemID" INTEGER NOT NULL,
    "type" VARCHAR(30) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "lastSync" TIMESTAMP,
    CONSTRAINT "pk_Integration" PRIMARY KEY ("integrationID")
);

CREATE TABLE "IntegrationError" (
    "integrationErrorID" INTEGER NOT NULL,
    "integrationID" INTEGER NOT NULL,
    "occurredAt" TIMESTAMP NOT NULL,
    "errorCode" VARCHAR(50),
    "description" VARCHAR(1000) NOT NULL,
    "resolvedAt" TIMESTAMP,
    CONSTRAINT "pk_IntegrationError" PRIMARY KEY ("integrationErrorID")
);

CREATE TABLE "ChangeRequest" (
    "changeID" INTEGER NOT NULL,
    "systemID" INTEGER NOT NULL,
    "employeeID" INTEGER NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "description" VARCHAR(1000) NOT NULL,
    "priority" VARCHAR(20) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "createdAt" TIMESTAMP NOT NULL,
    "completedAt" TIMESTAMP,
    CONSTRAINT "pk_ChangeRequest" PRIMARY KEY ("changeID")
);

CREATE TABLE "AuditLog" (
    "auditLogID" INTEGER NOT NULL,
    "systemID" INTEGER,
    "employeeID" INTEGER,
    "tableName" VARCHAR(80) NOT NULL,
    "recordID" VARCHAR(50) NOT NULL,
    "action" VARCHAR(30) NOT NULL,
    "oldValue" VARCHAR(1000),
    "newValue" VARCHAR(1000),
    "loggedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "pk_AuditLog" PRIMARY KEY ("auditLogID")
);

-- ===== Foreign keys =====
ALTER TABLE "Employee" ADD CONSTRAINT "fk_Employee_departmentID" FOREIGN KEY ("departmentID") REFERENCES "Department";
ALTER TABLE "Customer" ADD CONSTRAINT "fk_Customer_addressID" FOREIGN KEY ("addressID") REFERENCES "Address";
ALTER TABLE "Notification" ADD CONSTRAINT "fk_Notification_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "Notification" ADD CONSTRAINT "fk_Notification_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "Notification" ADD CONSTRAINT "fk_Notification_bookingID" FOREIGN KEY ("bookingID") REFERENCES "Booking";
ALTER TABLE "Notification" ADD CONSTRAINT "fk_Notification_channelID" FOREIGN KEY ("channelID") REFERENCES "CommunicationChannel";
ALTER TABLE "CustomerPreference" ADD CONSTRAINT "fk_CustomerPreference_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "CustomerSegmentMember" ADD CONSTRAINT "fk_CustomerSegmentMember_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "CustomerSegmentMember" ADD CONSTRAINT "fk_CustomerSegmentMember_segmentID" FOREIGN KEY ("segmentID") REFERENCES "CustomerSegment";
ALTER TABLE "Campaign" ADD CONSTRAINT "fk_Campaign_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "CampaignSegment" ADD CONSTRAINT "fk_CampaignSegment_campaignID" FOREIGN KEY ("campaignID") REFERENCES "Campaign";
ALTER TABLE "CampaignSegment" ADD CONSTRAINT "fk_CampaignSegment_segmentID" FOREIGN KEY ("segmentID") REFERENCES "CustomerSegment";
ALTER TABLE "CampaignChannel" ADD CONSTRAINT "fk_CampaignChannel_campaignID" FOREIGN KEY ("campaignID") REFERENCES "Campaign";
ALTER TABLE "CampaignChannel" ADD CONSTRAINT "fk_CampaignChannel_channelID" FOREIGN KEY ("channelID") REFERENCES "CommunicationChannel";
ALTER TABLE "CampaignTravelProduct" ADD CONSTRAINT "fk_CampaignTravelProduct_campaignID" FOREIGN KEY ("campaignID") REFERENCES "Campaign";
ALTER TABLE "CampaignTravelProduct" ADD CONSTRAINT "fk_CampaignTravelProduct_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "CampaignResult" ADD CONSTRAINT "fk_CampaignResult_campaignID" FOREIGN KEY ("campaignID") REFERENCES "Campaign";
ALTER TABLE "CampaignResult" ADD CONSTRAINT "fk_CampaignResult_channelID" FOREIGN KEY ("channelID") REFERENCES "CommunicationChannel";
ALTER TABLE "Promotion" ADD CONSTRAINT "fk_Promotion_campaignID" FOREIGN KEY ("campaignID") REFERENCES "Campaign";
ALTER TABLE "PromotionTravelProduct" ADD CONSTRAINT "fk_PromotionTravelProduct_promotionID" FOREIGN KEY ("promotionID") REFERENCES "Promotion";
ALTER TABLE "PromotionTravelProduct" ADD CONSTRAINT "fk_PromotionTravelProduct_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "Content" ADD CONSTRAINT "fk_Content_campaignID" FOREIGN KEY ("campaignID") REFERENCES "Campaign";
ALTER TABLE "Content" ADD CONSTRAINT "fk_Content_channelID" FOREIGN KEY ("channelID") REFERENCES "CommunicationChannel";
ALTER TABLE "ProductMedia" ADD CONSTRAINT "fk_ProductMedia_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "Favorite" ADD CONSTRAINT "fk_Favorite_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "Favorite" ADD CONSTRAINT "fk_Favorite_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "Inquiry" ADD CONSTRAINT "fk_Inquiry_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "Inquiry" ADD CONSTRAINT "fk_Inquiry_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "Quote" ADD CONSTRAINT "fk_Quote_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "Quote" ADD CONSTRAINT "fk_Quote_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "Quote" ADD CONSTRAINT "fk_Quote_inquiryID" FOREIGN KEY ("inquiryID") REFERENCES "Inquiry";
ALTER TABLE "Quote" ADD CONSTRAINT "fk_Quote_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "QuoteLine" ADD CONSTRAINT "fk_QuoteLine_quoteID" FOREIGN KEY ("quoteID") REFERENCES "Quote";
ALTER TABLE "QuoteLine" ADD CONSTRAINT "fk_QuoteLine_offerID" FOREIGN KEY ("offerID") REFERENCES "ComponentOffer";
ALTER TABLE "Booking" ADD CONSTRAINT "fk_Booking_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "Booking" ADD CONSTRAINT "fk_Booking_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "Booking" ADD CONSTRAINT "fk_Booking_quoteID" FOREIGN KEY ("quoteID") REFERENCES "Quote";
ALTER TABLE "Booking" ADD CONSTRAINT "fk_Booking_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "Booking" ADD CONSTRAINT "fk_Booking_promotionID" FOREIGN KEY ("promotionID") REFERENCES "Promotion";
ALTER TABLE "BookingLine" ADD CONSTRAINT "fk_BookingLine_bookingID" FOREIGN KEY ("bookingID") REFERENCES "Booking";
ALTER TABLE "BookingLine" ADD CONSTRAINT "fk_BookingLine_offerID" FOREIGN KEY ("offerID") REFERENCES "ComponentOffer";
ALTER TABLE "Cancellation" ADD CONSTRAINT "fk_Cancellation_bookingID" FOREIGN KEY ("bookingID") REFERENCES "Booking";
ALTER TABLE "ServiceTicket" ADD CONSTRAINT "fk_ServiceTicket_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "ServiceTicket" ADD CONSTRAINT "fk_ServiceTicket_bookingID" FOREIGN KEY ("bookingID") REFERENCES "Booking";
ALTER TABLE "ServiceTicket" ADD CONSTRAINT "fk_ServiceTicket_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "ServiceTicket" ADD CONSTRAINT "fk_ServiceTicket_channelID" FOREIGN KEY ("channelID") REFERENCES "CommunicationChannel";
ALTER TABLE "TicketStatusHistory" ADD CONSTRAINT "fk_TicketStatusHistory_ticketID" FOREIGN KEY ("ticketID") REFERENCES "ServiceTicket";
ALTER TABLE "TicketStatusHistory" ADD CONSTRAINT "fk_TicketStatusHistory_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "CustomerContact" ADD CONSTRAINT "fk_CustomerContact_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "CustomerContact" ADD CONSTRAINT "fk_CustomerContact_channelID" FOREIGN KEY ("channelID") REFERENCES "CommunicationChannel";
ALTER TABLE "CustomerContact" ADD CONSTRAINT "fk_CustomerContact_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "CustomerContact" ADD CONSTRAINT "fk_CustomerContact_ticketID" FOREIGN KEY ("ticketID") REFERENCES "ServiceTicket";
ALTER TABLE "CustomerFeedback" ADD CONSTRAINT "fk_CustomerFeedback_customerID" FOREIGN KEY ("customerID") REFERENCES "Customer";
ALTER TABLE "CustomerFeedback" ADD CONSTRAINT "fk_CustomerFeedback_bookingID" FOREIGN KEY ("bookingID") REFERENCES "Booking";
ALTER TABLE "CustomerFeedback" ADD CONSTRAINT "fk_CustomerFeedback_ticketID" FOREIGN KEY ("ticketID") REFERENCES "ServiceTicket";
ALTER TABLE "Supplier" ADD CONSTRAINT "fk_Supplier_addressID" FOREIGN KEY ("addressID") REFERENCES "Address";
ALTER TABLE "Negotiation" ADD CONSTRAINT "fk_Negotiation_supplierID" FOREIGN KEY ("supplierID") REFERENCES "Supplier";
ALTER TABLE "Negotiation" ADD CONSTRAINT "fk_Negotiation_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "Contract" ADD CONSTRAINT "fk_Contract_supplierID" FOREIGN KEY ("supplierID") REFERENCES "Supplier";
ALTER TABLE "Contract" ADD CONSTRAINT "fk_Contract_negotiationID" FOREIGN KEY ("negotiationID") REFERENCES "Negotiation";
ALTER TABLE "Flight" ADD CONSTRAINT "fk_Flight_travelComponentID" FOREIGN KEY ("travelComponentID") REFERENCES "TravelComponent";
ALTER TABLE "Accommodation" ADD CONSTRAINT "fk_Accommodation_travelComponentID" FOREIGN KEY ("travelComponentID") REFERENCES "TravelComponent";
ALTER TABLE "Accommodation" ADD CONSTRAINT "fk_Accommodation_addressID" FOREIGN KEY ("addressID") REFERENCES "Address";
ALTER TABLE "Activity" ADD CONSTRAINT "fk_Activity_travelComponentID" FOREIGN KEY ("travelComponentID") REFERENCES "TravelComponent";
ALTER TABLE "Activity" ADD CONSTRAINT "fk_Activity_addressID" FOREIGN KEY ("addressID") REFERENCES "Address";
ALTER TABLE "ComponentOffer" ADD CONSTRAINT "fk_ComponentOffer_travelComponentID" FOREIGN KEY ("travelComponentID") REFERENCES "TravelComponent";
ALTER TABLE "ComponentOffer" ADD CONSTRAINT "fk_ComponentOffer_contractID" FOREIGN KEY ("contractID") REFERENCES "Contract";
ALTER TABLE "PriceHistory" ADD CONSTRAINT "fk_PriceHistory_offerID" FOREIGN KEY ("offerID") REFERENCES "ComponentOffer";
ALTER TABLE "TravelProductComponent" ADD CONSTRAINT "fk_TravelProductComponent_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "TravelProductComponent" ADD CONSTRAINT "fk_TravelProductComponent_travelComponentID" FOREIGN KEY ("travelComponentID") REFERENCES "TravelComponent";
ALTER TABLE "DevelopmentProject" ADD CONSTRAINT "fk_DevelopmentProject_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "DevelopmentProject" ADD CONSTRAINT "fk_DevelopmentProject_travelProductID" FOREIGN KEY ("travelProductID") REFERENCES "TravelProduct";
ALTER TABLE "Milestone" ADD CONSTRAINT "fk_Milestone_developmentProjectID" FOREIGN KEY ("developmentProjectID") REFERENCES "DevelopmentProject";
ALTER TABLE "Task" ADD CONSTRAINT "fk_Task_developmentProjectID" FOREIGN KEY ("developmentProjectID") REFERENCES "DevelopmentProject";
ALTER TABLE "Task" ADD CONSTRAINT "fk_Task_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "ProjectTravelComponent" ADD CONSTRAINT "fk_ProjectTravelComponent_developmentProjectID" FOREIGN KEY ("developmentProjectID") REFERENCES "DevelopmentProject";
ALTER TABLE "ProjectTravelComponent" ADD CONSTRAINT "fk_ProjectTravelComponent_travelComponentID" FOREIGN KEY ("travelComponentID") REFERENCES "TravelComponent";
ALTER TABLE "PurchaseInvoice" ADD CONSTRAINT "fk_PurchaseInvoice_supplierID" FOREIGN KEY ("supplierID") REFERENCES "Supplier";
ALTER TABLE "PurchaseInvoiceLine" ADD CONSTRAINT "fk_PurchaseInvoiceLine_purchaseInvoiceID" FOREIGN KEY ("purchaseInvoiceID") REFERENCES "PurchaseInvoice";
ALTER TABLE "PurchaseInvoiceLine" ADD CONSTRAINT "fk_PurchaseInvoiceLine_offerID" FOREIGN KEY ("offerID") REFERENCES "ComponentOffer";
ALTER TABLE "Invoice" ADD CONSTRAINT "fk_Invoice_bookingID" FOREIGN KEY ("bookingID") REFERENCES "Booking";
ALTER TABLE "Payment" ADD CONSTRAINT "fk_Payment_invoiceID" FOREIGN KEY ("invoiceID") REFERENCES "Invoice";
ALTER TABLE "Payment" ADD CONSTRAINT "fk_Payment_paymentMethodID" FOREIGN KEY ("paymentMethodID") REFERENCES "PaymentMethod";
ALTER TABLE "PaymentReminder" ADD CONSTRAINT "fk_PaymentReminder_invoiceID" FOREIGN KEY ("invoiceID") REFERENCES "Invoice";
ALTER TABLE "PaymentReminder" ADD CONSTRAINT "fk_PaymentReminder_channelID" FOREIGN KEY ("channelID") REFERENCES "CommunicationChannel";
ALTER TABLE "Refund" ADD CONSTRAINT "fk_Refund_cancellationID" FOREIGN KEY ("cancellationID") REFERENCES "Cancellation";
ALTER TABLE "Refund" ADD CONSTRAINT "fk_Refund_paymentMethodID" FOREIGN KEY ("paymentMethodID") REFERENCES "PaymentMethod";
ALTER TABLE "JournalEntry" ADD CONSTRAINT "fk_JournalEntry_bookingID" FOREIGN KEY ("bookingID") REFERENCES "Booking";
ALTER TABLE "JournalEntry" ADD CONSTRAINT "fk_JournalEntry_purchaseInvoiceID" FOREIGN KEY ("purchaseInvoiceID") REFERENCES "PurchaseInvoice";
ALTER TABLE "JournalEntryLine" ADD CONSTRAINT "fk_JournalEntryLine_journalEntryID" FOREIGN KEY ("journalEntryID") REFERENCES "JournalEntry";
ALTER TABLE "JournalEntryLine" ADD CONSTRAINT "fk_JournalEntryLine_accountCode" FOREIGN KEY ("accountCode") REFERENCES "LedgerAccount";
ALTER TABLE "Integration" ADD CONSTRAINT "fk_Integration_sourceSystemID" FOREIGN KEY ("sourceSystemID") REFERENCES "System";
ALTER TABLE "Integration" ADD CONSTRAINT "fk_Integration_targetSystemID" FOREIGN KEY ("targetSystemID") REFERENCES "System";
ALTER TABLE "IntegrationError" ADD CONSTRAINT "fk_IntegrationError_integrationID" FOREIGN KEY ("integrationID") REFERENCES "Integration";
ALTER TABLE "ChangeRequest" ADD CONSTRAINT "fk_ChangeRequest_systemID" FOREIGN KEY ("systemID") REFERENCES "System";
ALTER TABLE "ChangeRequest" ADD CONSTRAINT "fk_ChangeRequest_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
ALTER TABLE "AuditLog" ADD CONSTRAINT "fk_AuditLog_systemID" FOREIGN KEY ("systemID") REFERENCES "System";
ALTER TABLE "AuditLog" ADD CONSTRAINT "fk_AuditLog_employeeID" FOREIGN KEY ("employeeID") REFERENCES "Employee";
