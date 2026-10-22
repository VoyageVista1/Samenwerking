# VoyageVista — ERD 2.0 (gezamenlijk datamodel)

Gezamenlijk datamodel van alle zes afdelingen. Diagram: `VoyageVista_ERD_2.0.png` / `.svg`, interactief: `VoyageVista_ERD_2.0.html`, database: `VoyageVista_ERD_2.0_schema.sql` (PostgreSQL, getest).

## Wat is er verbeterd ten opzichte van ERD 1.0

1. Alle **98 relaties** staan nu als foreign key in de tabellen. In 1.0 ontbraken de FK-kolommen en de lijnen in het diagram.
2. `Integration` heeft twee FK's naar `System`: `sourceSystemID` en `targetSystemID`. De dubbele regel in 1.0 was precies deze bron/doel-relatie.
3. `Flight`, `Accommodation` en `Activity` zijn **subtypes** van `TravelComponent` (1 op 0..1, PK = FK), niet 1 op veel.
4. `Payment.paymentMethod` (tekst) is vervangen door de FK `paymentMethodID`; `PaymentMethod` heeft een echte sleutel en een unieke `code`.
5. Bedragen hebben twee decimalen: `numeric(12,0)` wordt `numeric(12,2)` bij o.a. `Campaign.budget`, `ComponentOffer.price` en `CampaignResult.revenue`.
6. Tijdstippen zijn `timestamp` waar de tijd telt: vertrek/aankomst van vluchten, tickets, betalingen, audit log.
7. Dubbele gegevens weg uit `TravelComponent`: inkoopprijs, valuta en beschikbaarheid staan alleen nog in `ComponentOffer` (met `PriceHistory`).
8. Nieuwe FK's die de processen sluiten: `Booking.promotionID` (campagneresultaat meten), `Quote.inquiryID` (aanvraag → offerte), `Contract.negotiationID`, `ServiceTicket.channelID`, `DevelopmentProject.travelProductID`.
9. Nieuwe entiteit `LedgerAccount` (grootboek) voor `JournalEntryLine`. Een `JournalEntry` kan nu ook een `PurchaseInvoice` verantwoorden.
10. Ontbrekende attributen toegevoegd: `Flight.airline`, `Booking.bookingNumber`, `Promotion.promoCode`, `Content.title`, `AuditLog.recordID`, eigenaar bij `Campaign`.
11. Namen en types opgeschoond: `bit` → `boolean`, kolommen als `date`/`timestamp` hernoemd (bijv. `refundDate`, `loggedAt`), landen en valuta als ISO-code.

## Notatie

- **PK** = primaire sleutel, **FK** = foreign key, **U** = uniek, **N** = mag leeg zijn (nullable).
- Crow's foot: `||` precies één, `o|` nul of één, `o<` nul of meer.
- Koppeltabellen (veel-op-veel) hebben een samengestelde PK uit twee FK's.
- `Flight`, `Accommodation` en `Activity` zijn **subtypes** van `TravelComponent` (PK = FK, 1 op 0..1).

## Overzicht — 59 entiteiten, 98 relaties

| Afdeling | Entiteiten |
|---|---|
| Algemeen (gedeeld) | `Address`, `Department`, `Employee`, `Customer`, `CommunicationChannel`, `Notification` |
| Marketing & Communicatie | `CustomerPreference`, `CustomerSegment`, `CustomerSegmentMember`, `Campaign`, `CampaignSegment`, `CampaignChannel`, `CampaignTravelProduct`, `CampaignResult`, `Promotion`, `PromotionTravelProduct`, `Content` |
| Sales & Boekingen | `TravelProduct`, `ProductMedia`, `Favorite`, `Inquiry`, `Quote`, `QuoteLine`, `Booking`, `BookingLine`, `Cancellation` |
| Klantenservice & Support | `ServiceTicket`, `TicketStatusHistory`, `CustomerContact`, `CustomerFeedback` |
| Productontwikkeling & Inkoop | `Supplier`, `Negotiation`, `Contract`, `TravelComponent`, `Flight`, `Accommodation`, `Activity`, `ComponentOffer`, `PriceHistory`, `TravelProductComponent`, `DevelopmentProject`, `Milestone`, `Task`, `ProjectTravelComponent`, `PurchaseInvoice`, `PurchaseInvoiceLine` |
| Financiën & Administratie | `Invoice`, `PaymentMethod`, `Payment`, `PaymentReminder`, `Refund`, `LedgerAccount`, `JournalEntry`, `JournalEntryLine` |
| IT & Innovatie | `System`, `Integration`, `IntegrationError`, `ChangeRequest`, `AuditLog` |

## Relaties

Lees als: *één ouder ‹werkwoord› nul of meer kinderen; elk kind hoort bij precies één / nul of één ouder.*

| # | Ouder | Relatie | Kind | Via FK | Kind hoort bij |
|---|---|---|---|---|---|
| 1 | `Address` | is locatie van nul of meer | `Accommodation` | `addressID` | precies één `Address` |
| 2 | `Address` | is locatie van nul of meer | `Activity` | `addressID` | nul of één `Address` |
| 3 | `Address` | is woonadres van nul of meer | `Customer` | `addressID` | nul of één `Address` |
| 4 | `Address` | is adres van nul of meer | `Supplier` | `addressID` | nul of één `Address` |
| 5 | `CommunicationChannel` | heeft nul of meer | `CampaignChannel` | `channelID` | precies één `CommunicationChannel` |
| 6 | `CommunicationChannel` | heeft nul of meer | `CampaignResult` | `channelID` | nul of één `CommunicationChannel` |
| 7 | `CommunicationChannel` | heeft nul of meer | `Content` | `channelID` | precies één `CommunicationChannel` |
| 8 | `CommunicationChannel` | heeft nul of meer | `CustomerContact` | `channelID` | precies één `CommunicationChannel` |
| 9 | `CommunicationChannel` | heeft nul of meer | `Notification` | `channelID` | precies één `CommunicationChannel` |
| 10 | `CommunicationChannel` | heeft nul of meer | `PaymentReminder` | `channelID` | precies één `CommunicationChannel` |
| 11 | `CommunicationChannel` | heeft nul of meer | `ServiceTicket` | `channelID` | precies één `CommunicationChannel` |
| 12 | `Customer` | plaatst nul of meer | `Booking` | `customerID` | precies één `Customer` |
| 13 | `Customer` | heeft nul of meer | `CustomerContact` | `customerID` | precies één `Customer` |
| 14 | `Customer` | geeft nul of meer | `CustomerFeedback` | `customerID` | precies één `Customer` |
| 15 | `Customer` | heeft nul of meer | `CustomerPreference` | `customerID` | precies één `Customer` |
| 16 | `Customer` | heeft nul of meer | `CustomerSegmentMember` | `customerID` | precies één `Customer` |
| 17 | `Customer` | bewaart nul of meer | `Favorite` | `customerID` | precies één `Customer` |
| 18 | `Customer` | doet nul of meer | `Inquiry` | `customerID` | precies één `Customer` |
| 19 | `Customer` | ontvangt nul of meer | `Notification` | `customerID` | nul of één `Customer` |
| 20 | `Customer` | ontvangt nul of meer | `Quote` | `customerID` | precies één `Customer` |
| 21 | `Customer` | meldt nul of meer | `ServiceTicket` | `customerID` | precies één `Customer` |
| 22 | `Department` | heeft nul of meer | `Employee` | `departmentID` | precies één `Department` |
| 23 | `Employee` | heeft nul of meer | `AuditLog` | `employeeID` | nul of één `Employee` |
| 24 | `Employee` | heeft nul of meer | `Booking` | `employeeID` | nul of één `Employee` |
| 25 | `Employee` | heeft nul of meer | `Campaign` | `employeeID` | precies één `Employee` |
| 26 | `Employee` | heeft nul of meer | `ChangeRequest` | `employeeID` | precies één `Employee` |
| 27 | `Employee` | heeft nul of meer | `CustomerContact` | `employeeID` | nul of één `Employee` |
| 28 | `Employee` | heeft nul of meer | `DevelopmentProject` | `employeeID` | precies één `Employee` |
| 29 | `Employee` | heeft nul of meer | `Negotiation` | `employeeID` | precies één `Employee` |
| 30 | `Employee` | ontvangt nul of meer | `Notification` | `employeeID` | nul of één `Employee` |
| 31 | `Employee` | heeft nul of meer | `Quote` | `employeeID` | nul of één `Employee` |
| 32 | `Employee` | heeft nul of meer | `ServiceTicket` | `employeeID` | nul of één `Employee` |
| 33 | `Employee` | heeft nul of meer | `Task` | `employeeID` | nul of één `Employee` |
| 34 | `Employee` | heeft nul of meer | `TicketStatusHistory` | `employeeID` | nul of één `Employee` |
| 35 | `Campaign` | heeft nul of meer | `CampaignChannel` | `campaignID` | precies één `Campaign` |
| 36 | `Campaign` | heeft nul of meer | `CampaignResult` | `campaignID` | precies één `Campaign` |
| 37 | `Campaign` | heeft nul of meer | `CampaignSegment` | `campaignID` | precies één `Campaign` |
| 38 | `Campaign` | heeft nul of meer | `CampaignTravelProduct` | `campaignID` | precies één `Campaign` |
| 39 | `Campaign` | heeft nul of meer | `Content` | `campaignID` | precies één `Campaign` |
| 40 | `Campaign` | bevat nul of meer | `Promotion` | `campaignID` | precies één `Campaign` |
| 41 | `CustomerSegment` | heeft nul of meer | `CampaignSegment` | `segmentID` | precies één `CustomerSegment` |
| 42 | `CustomerSegment` | heeft nul of meer | `CustomerSegmentMember` | `segmentID` | precies één `CustomerSegment` |
| 43 | `Promotion` | wordt gebruikt bij nul of meer | `Booking` | `promotionID` | nul of één `Promotion` |
| 44 | `Promotion` | heeft nul of meer | `PromotionTravelProduct` | `promotionID` | precies één `Promotion` |
| 45 | `Booking` | heeft nul of meer | `BookingLine` | `bookingID` | precies één `Booking` |
| 46 | `Booking` | wordt geannuleerd met nul of meer | `Cancellation` | `bookingID` | precies één `Booking` |
| 47 | `Booking` | heeft nul of meer | `CustomerFeedback` | `bookingID` | nul of één `Booking` |
| 48 | `Booking` | wordt gefactureerd met nul of meer | `Invoice` | `bookingID` | precies één `Booking` |
| 49 | `Booking` | wordt verantwoord in nul of meer | `JournalEntry` | `bookingID` | nul of één `Booking` |
| 50 | `Booking` | heeft nul of meer | `Notification` | `bookingID` | nul of één `Booking` |
| 51 | `Booking` | heeft nul of meer | `ServiceTicket` | `bookingID` | nul of één `Booking` |
| 52 | `Cancellation` | leidt tot nul of meer | `Refund` | `cancellationID` | precies één `Cancellation` |
| 53 | `Inquiry` | leidt tot nul of meer | `Quote` | `inquiryID` | nul of één `Inquiry` |
| 54 | `Quote` | wordt omgezet in nul of meer | `Booking` | `quoteID` | nul of één `Quote` |
| 55 | `Quote` | heeft nul of meer | `QuoteLine` | `quoteID` | precies één `Quote` |
| 56 | `TravelProduct` | heeft nul of meer | `Booking` | `travelProductID` | nul of één `TravelProduct` |
| 57 | `TravelProduct` | heeft nul of meer | `CampaignTravelProduct` | `travelProductID` | precies één `TravelProduct` |
| 58 | `TravelProduct` | is resultaat van nul of meer | `DevelopmentProject` | `travelProductID` | nul of één `TravelProduct` |
| 59 | `TravelProduct` | heeft nul of meer | `Favorite` | `travelProductID` | precies één `TravelProduct` |
| 60 | `TravelProduct` | heeft nul of meer | `Inquiry` | `travelProductID` | nul of één `TravelProduct` |
| 61 | `TravelProduct` | heeft nul of meer | `ProductMedia` | `travelProductID` | precies één `TravelProduct` |
| 62 | `TravelProduct` | heeft nul of meer | `PromotionTravelProduct` | `travelProductID` | precies één `TravelProduct` |
| 63 | `TravelProduct` | heeft nul of meer | `Quote` | `travelProductID` | nul of één `TravelProduct` |
| 64 | `TravelProduct` | heeft nul of meer | `TravelProductComponent` | `travelProductID` | precies één `TravelProduct` |
| 65 | `ServiceTicket` | heeft nul of meer | `CustomerContact` | `ticketID` | nul of één `ServiceTicket` |
| 66 | `ServiceTicket` | heeft nul of meer | `CustomerFeedback` | `ticketID` | nul of één `ServiceTicket` |
| 67 | `ServiceTicket` | heeft nul of meer | `TicketStatusHistory` | `ticketID` | precies één `ServiceTicket` |
| 68 | `ComponentOffer` | wordt geboekt in nul of meer | `BookingLine` | `offerID` | precies één `ComponentOffer` |
| 69 | `ComponentOffer` | heeft nul of meer | `PriceHistory` | `offerID` | precies één `ComponentOffer` |
| 70 | `ComponentOffer` | heeft nul of meer | `PurchaseInvoiceLine` | `offerID` | precies één `ComponentOffer` |
| 71 | `ComponentOffer` | wordt geoffreerd in nul of meer | `QuoteLine` | `offerID` | precies één `ComponentOffer` |
| 72 | `Contract` | bevat nul of meer | `ComponentOffer` | `contractID` | precies één `Contract` |
| 73 | `DevelopmentProject` | heeft nul of meer | `Milestone` | `developmentProjectID` | precies één `DevelopmentProject` |
| 74 | `DevelopmentProject` | heeft nul of meer | `ProjectTravelComponent` | `developmentProjectID` | precies één `DevelopmentProject` |
| 75 | `DevelopmentProject` | bestaat uit nul of meer | `Task` | `developmentProjectID` | precies één `DevelopmentProject` |
| 76 | `Negotiation` | resulteert in nul of meer | `Contract` | `negotiationID` | nul of één `Negotiation` |
| 77 | `PurchaseInvoice` | wordt verantwoord in nul of meer | `JournalEntry` | `purchaseInvoiceID` | nul of één `PurchaseInvoice` |
| 78 | `PurchaseInvoice` | heeft nul of meer | `PurchaseInvoiceLine` | `purchaseInvoiceID` | precies één `PurchaseInvoice` |
| 79 | `Supplier` | sluit nul of meer | `Contract` | `supplierID` | precies één `Supplier` |
| 80 | `Supplier` | voert nul of meer | `Negotiation` | `supplierID` | precies één `Supplier` |
| 81 | `Supplier` | heeft nul of meer | `PurchaseInvoice` | `supplierID` | precies één `Supplier` |
| 82 | `TravelComponent` | is (subtype) nul of één | `Accommodation` | `travelComponentID` | precies één `TravelComponent` |
| 83 | `TravelComponent` | is (subtype) nul of één | `Activity` | `travelComponentID` | precies één `TravelComponent` |
| 84 | `TravelComponent` | heeft nul of meer | `ComponentOffer` | `travelComponentID` | precies één `TravelComponent` |
| 85 | `TravelComponent` | is (subtype) nul of één | `Flight` | `travelComponentID` | precies één `TravelComponent` |
| 86 | `TravelComponent` | heeft nul of meer | `ProjectTravelComponent` | `travelComponentID` | precies één `TravelComponent` |
| 87 | `TravelComponent` | heeft nul of meer | `TravelProductComponent` | `travelComponentID` | precies één `TravelComponent` |
| 88 | `Invoice` | wordt betaald met nul of meer | `Payment` | `invoiceID` | precies één `Invoice` |
| 89 | `Invoice` | krijgt nul of meer | `PaymentReminder` | `invoiceID` | precies één `Invoice` |
| 90 | `JournalEntry` | heeft nul of meer | `JournalEntryLine` | `journalEntryID` | precies één `JournalEntry` |
| 91 | `LedgerAccount` | wordt geboekt op nul of meer | `JournalEntryLine` | `accountCode` | precies één `LedgerAccount` |
| 92 | `PaymentMethod` | heeft nul of meer | `Payment` | `paymentMethodID` | nul of één `PaymentMethod` |
| 93 | `PaymentMethod` | heeft nul of meer | `Refund` | `paymentMethodID` | precies één `PaymentMethod` |
| 94 | `Integration` | heeft nul of meer | `IntegrationError` | `integrationID` | precies één `Integration` |
| 95 | `System` | heeft nul of meer | `AuditLog` | `systemID` | nul of één `System` |
| 96 | `System` | heeft nul of meer | `ChangeRequest` | `systemID` | precies één `System` |
| 97 | `System` | is bron/doel van nul of meer | `Integration` | `sourceSystemID` | precies één `System` |
| 98 | `System` | is bron/doel van nul of meer | `Integration` | `targetSystemID` | precies één `System` |

## Datadictionary

### Algemeen (gedeeld)

#### Address

Adres van een klant, leverancier, accommodatie of activiteit.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `addressID` | integer | PK | nee | Uniek adres |
| `street` | varchar(80) |  | nee | Straatnaam |
| `houseNumber` | varchar(10) |  | nee | Huisnummer |
| `addressSuffix` | varchar(10) |  | ja | Toevoeging |
| `postalCode` | varchar(10) |  | nee | Postcode |
| `city` | varchar(80) |  | nee | Plaats |
| `country` | char(2) |  | nee | Landcode ISO 3166-1 (bijv. NL) |

#### Department

Afdeling van VoyageVista.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `departmentID` | integer | PK | nee |  |
| `name` | varchar(60) | U | nee | Afdelingsnaam |

#### Employee

Medewerker van VoyageVista.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `employeeID` | integer | PK | nee |  |
| `departmentID` | integer | FK → Department | nee | Afdeling waar de medewerker werkt |
| `firstName` | varchar(50) |  | nee |  |
| `namePrefix` | varchar(20) |  | ja | Tussenvoegsel |
| `lastName` | varchar(80) |  | nee |  |
| `email` | varchar(254) | U | nee |  |
| `active` | boolean |  | nee | In dienst ja/nee |

#### Customer

Klant (reiziger) - centrale entiteit voor het 360-graden klantbeeld.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `customerID` | integer | PK | nee |  |
| `addressID` | integer | FK → Address | ja | Woonadres |
| `firstName` | varchar(50) |  | nee |  |
| `namePrefix` | varchar(20) |  | ja |  |
| `lastName` | varchar(80) |  | nee |  |
| `birthDate` | date |  | ja |  |
| `email` | varchar(254) | U | nee |  |
| `phone` | varchar(25) |  | ja |  |
| `marketingConsent` | boolean |  | nee | Toestemming marketing (AVG) |
| `createdAt` | timestamp |  | nee |  |

#### CommunicationChannel

Kanaal: e-mail, telefoon, Instagram, TikTok, app-push, ...

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `channelID` | integer | PK | nee |  |
| `name` | varchar(40) | U | nee |  |

#### Notification

Melding aan een klant of medewerker (bijv. boekingsbevestiging).

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `notificationID` | integer | PK | nee |  |
| `customerID` | integer | FK → Customer | ja | Ontvanger (klant) |
| `employeeID` | integer | FK → Employee | ja | Ontvanger (medewerker) |
| `bookingID` | integer | FK → Booking | ja | Betreffende boeking |
| `channelID` | integer | FK → CommunicationChannel | nee | Verzonden via |
| `type` | varchar(30) |  | nee |  |
| `subject` | varchar(120) |  | nee |  |
| `message` | varchar(500) |  | nee |  |
| `createdAt` | timestamp |  | nee |  |
| `readAt` | timestamp |  | ja |  |

### Marketing & Communicatie

#### CustomerPreference

Voorkeur van een klant (bestemming, reistype, budget).

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `preferenceID` | integer | PK | nee |  |
| `customerID` | integer | FK → Customer | nee |  |
| `category` | varchar(50) |  | nee | Bijv. bestemming, reistype |
| `value` | varchar(120) |  | nee |  |
| `priority` | smallint |  | ja |  |
| `updatedAt` | timestamp |  | nee |  |

#### CustomerSegment

Doelgroep, bijv. 'backpackers 18-19'.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `segmentID` | integer | PK | nee |  |
| `name` | varchar(80) | U | nee |  |
| `description` | varchar(300) |  | ja |  |
| `active` | boolean |  | nee |  |

#### CustomerSegmentMember

Koppeltabel klant ↔ segment.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `customerID` | integer | PK, FK → Customer | nee |  |
| `segmentID` | integer | PK, FK → CustomerSegment | nee |  |
| `addedAt` | date |  | nee |  |

#### Campaign

Marketingcampagne.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `campaignID` | integer | PK | nee |  |
| `employeeID` | integer | FK → Employee | nee | Campagne-eigenaar |
| `name` | varchar(120) |  | nee |  |
| `startDate` | date |  | nee |  |
| `endDate` | date |  | ja |  |
| `status` | varchar(30) |  | nee |  |
| `budget` | numeric(12,2) |  | ja |  |

#### CampaignSegment

Koppeltabel campagne ↔ doelgroep.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `campaignID` | integer | PK, FK → Campaign | nee |  |
| `segmentID` | integer | PK, FK → CustomerSegment | nee |  |

#### CampaignChannel

Koppeltabel campagne ↔ kanaal.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `campaignID` | integer | PK, FK → Campaign | nee |  |
| `channelID` | integer | PK, FK → CommunicationChannel | nee |  |

#### CampaignTravelProduct

Koppeltabel campagne ↔ gepromote reis.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `campaignID` | integer | PK, FK → Campaign | nee |  |
| `travelProductID` | integer | PK, FK → TravelProduct | nee |  |

#### CampaignResult

Gemeten resultaat van een campagne per kanaal en datum.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `resultID` | integer | PK | nee |  |
| `campaignID` | integer | FK → Campaign | nee |  |
| `channelID` | integer | FK → CommunicationChannel | ja | Kanaal van de meting |
| `measurementDate` | date |  | nee |  |
| `impressions` | integer |  | nee |  |
| `clicks` | integer |  | nee |  |
| `inquiries` | integer |  | nee |  |
| `bookings` | integer |  | nee |  |
| `revenue` | numeric(14,2) |  | nee |  |

#### Promotion

Actie/korting binnen een campagne.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `promotionID` | integer | PK | nee |  |
| `campaignID` | integer | FK → Campaign | nee |  |
| `promoCode` | varchar(30) | U | ja | Kortingscode |
| `description` | varchar(255) |  | nee |  |
| `discountPct` | numeric(5,2) |  | ja |  |
| `startDate` | date |  | nee |  |
| `endDate` | date |  | nee |  |

#### PromotionTravelProduct

Actieprijs van een reis binnen een promotie.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `promotionID` | integer | PK, FK → Promotion | nee |  |
| `travelProductID` | integer | PK, FK → TravelProduct | nee |  |
| `promotionalPrice` | numeric(12,2) |  | nee |  |

#### Content

Campagne-uiting (post, mail, video) op een kanaal.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `contentID` | integer | PK | nee |  |
| `campaignID` | integer | FK → Campaign | nee |  |
| `channelID` | integer | FK → CommunicationChannel | nee |  |
| `title` | varchar(150) |  | nee |  |
| `body` | varchar(1000) |  | nee |  |
| `publicationDate` | date |  | ja |  |

### Sales & Boekingen

#### TravelProduct

Verkoopbare reis (pakket) zoals de klant die ziet.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `travelProductID` | integer | PK | nee |  |
| `name` | varchar(120) |  | nee |  |
| `description` | varchar(500) |  | ja |  |
| `destination` | varchar(120) |  | nee |  |
| `durationDays` | smallint |  | nee |  |
| `salePrice` | numeric(12,2) |  | nee |  |
| `currency` | char(3) |  | nee | ISO 4217, bijv. EUR |
| `status` | varchar(30) |  | nee |  |
| `publicationDate` | date |  | ja |  |

#### ProductMedia

Foto/video bij een reis.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `mediaID` | integer | PK | nee |  |
| `travelProductID` | integer | FK → TravelProduct | nee |  |
| `type` | varchar(30) |  | nee |  |
| `url` | varchar(500) |  | nee |  |
| `altText` | varchar(255) |  | ja |  |
| `sequence` | smallint |  | nee |  |
| `active` | boolean |  | nee |  |

#### Favorite

Reis die een klant als favoriet heeft opgeslagen.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `customerID` | integer | PK, FK → Customer | nee |  |
| `travelProductID` | integer | PK, FK → TravelProduct | nee |  |
| `addedAt` | timestamp |  | nee |  |

#### Inquiry

Reiswens/aanvraag van een klant.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `inquiryID` | integer | PK | nee |  |
| `customerID` | integer | FK → Customer | nee |  |
| `travelProductID` | integer | FK → TravelProduct | ja | Leeg bij een vrije reiswens |
| `description` | varchar(500) |  | nee |  |
| `status` | varchar(30) |  | nee |  |
| `createdAt` | timestamp |  | nee |  |

#### Quote

Offerte voor een klant.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `quoteID` | integer | PK | nee |  |
| `customerID` | integer | FK → Customer | nee |  |
| `employeeID` | integer | FK → Employee | ja | Opgesteld door |
| `inquiryID` | integer | FK → Inquiry | ja | Naar aanleiding van aanvraag |
| `travelProductID` | integer | FK → TravelProduct | ja | Basisreis |
| `createdAt` | timestamp |  | nee |  |
| `validUntil` | date |  | nee |  |
| `status` | varchar(30) |  | nee |  |
| `comment` | varchar(500) |  | ja |  |

#### QuoteLine

Regel van een offerte (één aanbod van een reisonderdeel).

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `quoteID` | integer | PK, FK → Quote | nee |  |
| `lineNumber` | smallint | PK | nee |  |
| `offerID` | integer | FK → ComponentOffer | nee |  |
| `quantity` | smallint |  | nee |  |
| `unitPrice` | numeric(12,2) |  | nee |  |
| `discountPct` | numeric(5,2) |  | ja |  |

#### Booking

Boeking van een klant.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `bookingID` | integer | PK | nee |  |
| `bookingNumber` | varchar(20) | U | nee | Zichtbaar boekingsnummer |
| `customerID` | integer | FK → Customer | nee |  |
| `employeeID` | integer | FK → Employee | ja | Behandelend medewerker |
| `quoteID` | integer | FK → Quote | ja | Geaccepteerde offerte |
| `travelProductID` | integer | FK → TravelProduct | ja |  |
| `promotionID` | integer | FK → Promotion | ja | Gebruikte actie (campagnemeting) |
| `bookingDate` | timestamp |  | nee |  |
| `status` | varchar(30) |  | nee |  |
| `currency` | char(3) |  | nee |  |

#### BookingLine

Regel van een boeking (één aanbod van een reisonderdeel).

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `bookingID` | integer | PK, FK → Booking | nee |  |
| `lineNumber` | smallint | PK | nee |  |
| `offerID` | integer | FK → ComponentOffer | nee |  |
| `quantity` | smallint |  | nee |  |
| `unitPrice` | numeric(12,2) |  | nee |  |
| `discountPct` | numeric(5,2) |  | ja |  |

#### Cancellation

Annulering van een boeking.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `cancellationID` | integer | PK | nee |  |
| `bookingID` | integer | FK → Booking | nee |  |
| `cancellationDate` | date |  | nee |  |
| `reason` | varchar(255) |  | nee |  |
| `status` | varchar(30) |  | nee |  |
| `refundAmount` | numeric(12,2) |  | nee | Berekend terug te betalen bedrag |

### Klantenservice & Support

#### ServiceTicket

Vraag of klacht van een klant.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `ticketID` | integer | PK | nee |  |
| `customerID` | integer | FK → Customer | nee |  |
| `bookingID` | integer | FK → Booking | ja |  |
| `employeeID` | integer | FK → Employee | ja | Toegewezen medewerker |
| `channelID` | integer | FK → CommunicationChannel | nee | Binnengekomen via |
| `type` | varchar(20) |  | nee | vraag / klacht / wijziging |
| `subject` | varchar(150) |  | nee |  |
| `description` | varchar(1000) |  | nee |  |
| `priority` | varchar(20) |  | nee |  |
| `status` | varchar(30) |  | nee |  |
| `createdAt` | timestamp |  | nee |  |
| `closedAt` | timestamp |  | ja |  |
| `slaDeadline` | timestamp |  | ja |  |

#### TicketStatusHistory

Statuswijzigingen van een ticket (uniforme afhandeling).

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `statusHistoryID` | integer | PK | nee |  |
| `ticketID` | integer | FK → ServiceTicket | nee |  |
| `employeeID` | integer | FK → Employee | ja |  |
| `status` | varchar(30) |  | nee |  |
| `changedAt` | timestamp |  | nee |  |
| `explanation` | varchar(500) |  | ja |  |

#### CustomerContact

Elk contactmoment met een klant, via welk kanaal dan ook.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `contactID` | integer | PK | nee |  |
| `customerID` | integer | FK → Customer | nee |  |
| `channelID` | integer | FK → CommunicationChannel | nee |  |
| `employeeID` | integer | FK → Employee | ja |  |
| `ticketID` | integer | FK → ServiceTicket | ja |  |
| `contactDate` | timestamp |  | nee |  |
| `direction` | varchar(15) |  | nee | inkomend / uitgaand |
| `summary` | varchar(1000) |  | nee |  |

#### CustomerFeedback

Beoordeling van een klant.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `feedbackID` | integer | PK | nee |  |
| `customerID` | integer | FK → Customer | nee |  |
| `bookingID` | integer | FK → Booking | ja |  |
| `ticketID` | integer | FK → ServiceTicket | ja |  |
| `score` | smallint |  | nee | 1 t/m 5 |
| `comment` | varchar(1000) |  | ja |  |
| `feedbackDate` | date |  | nee |  |

### Productontwikkeling & Inkoop

#### Supplier

Leverancier: airline, hotel, activiteitenaanbieder.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `supplierID` | integer | PK | nee |  |
| `addressID` | integer | FK → Address | ja |  |
| `name` | varchar(120) |  | nee |  |
| `type` | varchar(50) |  | nee |  |
| `email` | varchar(254) |  | ja |  |
| `phone` | varchar(25) |  | ja |  |
| `active` | boolean |  | nee |  |
| `lastModified` | timestamp |  | nee |  |

#### Negotiation

Onderhandeling met een leverancier.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `negotiationID` | integer | PK | nee |  |
| `supplierID` | integer | FK → Supplier | nee |  |
| `employeeID` | integer | FK → Employee | nee | Inkoper |
| `subject` | varchar(150) |  | nee |  |
| `startDate` | date |  | nee |  |
| `status` | varchar(30) |  | nee |  |
| `result` | varchar(500) |  | ja |  |
| `priority` | varchar(20) |  | nee |  |
| `lastUpdated` | timestamp |  | nee |  |
| `remarks` | varchar(500) |  | ja |  |

#### Contract

Contract met een leverancier.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `contractID` | integer | PK | nee |  |
| `supplierID` | integer | FK → Supplier | nee |  |
| `negotiationID` | integer | FK → Negotiation | ja | Uitkomst van onderhandeling |
| `contractNumber` | varchar(60) | U | nee |  |
| `startDate` | date |  | nee |  |
| `endDate` | date |  | ja |  |
| `status` | varchar(30) |  | nee |  |
| `terms` | varchar(1000) |  | ja |  |
| `contractValue` | numeric(12,2) |  | ja |  |

#### TravelComponent

Supertype voor een los reisonderdeel (vlucht, accommodatie, activiteit).

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `travelComponentID` | integer | PK | nee |  |
| `type` | varchar(30) |  | nee | FLIGHT / ACCOMMODATION / ACTIVITY |
| `name` | varchar(120) |  | nee |  |
| `description` | varchar(500) |  | ja |  |
| `status` | varchar(30) |  | nee |  |
| `lastModified` | timestamp |  | nee |  |

#### Flight

Subtype van TravelComponent.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `travelComponentID` | integer | PK, FK → TravelComponent | nee |  |
| `flightNumber` | varchar(15) |  | nee |  |
| `airline` | varchar(80) |  | nee |  |
| `departureAirport` | char(3) |  | nee | IATA-code |
| `arrivalAirport` | char(3) |  | nee | IATA-code |
| `departureTime` | timestamp |  | nee |  |
| `arrivalTime` | timestamp |  | nee |  |

#### Accommodation

Subtype van TravelComponent.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `travelComponentID` | integer | PK, FK → TravelComponent | nee |  |
| `addressID` | integer | FK → Address | nee |  |
| `roomType` | varchar(80) |  | ja |  |
| `numberOfNights` | smallint |  | ja |  |
| `stars` | smallint |  | ja | 0 t/m 5 |

#### Activity

Subtype van TravelComponent.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `travelComponentID` | integer | PK, FK → TravelComponent | nee |  |
| `addressID` | integer | FK → Address | ja |  |
| `durationMinutes` | integer |  | ja |  |
| `minimumAge` | smallint |  | ja |  |

#### ComponentOffer

Ingekocht aanbod: prijs en beschikbaarheid van een onderdeel onder een contract.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `offerID` | integer | PK | nee |  |
| `travelComponentID` | integer | FK → TravelComponent | nee |  |
| `contractID` | integer | FK → Contract | nee |  |
| `price` | numeric(12,2) |  | nee | Inkoopprijs |
| `currency` | char(3) |  | nee |  |
| `availableQuantity` | integer |  | nee |  |
| `validFrom` | date |  | nee |  |
| `validUntil` | date |  | ja |  |
| `lastUpdated` | timestamp |  | nee |  |

#### PriceHistory

Prijsverloop van een aanbod.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `priceHistoryID` | integer | PK | nee |  |
| `offerID` | integer | FK → ComponentOffer | nee |  |
| `price` | numeric(12,2) |  | nee |  |
| `validFrom` | date |  | nee |  |
| `validUntil` | date |  | ja |  |
| `recordedAt` | timestamp |  | nee |  |

#### TravelProductComponent

Samenstelling van een reis uit reisonderdelen.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `travelProductID` | integer | PK, FK → TravelProduct | nee |  |
| `travelComponentID` | integer | PK, FK → TravelComponent | nee |  |
| `sequence` | smallint |  | nee |  |
| `defaultQuantity` | smallint |  | nee |  |
| `included` | boolean |  | nee |  |

#### DevelopmentProject

Project om een nieuwe reis te ontwikkelen.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `developmentProjectID` | integer | PK | nee |  |
| `employeeID` | integer | FK → Employee | nee | Projectleider |
| `travelProductID` | integer | FK → TravelProduct | ja | Resulterende reis |
| `projectName` | varchar(120) |  | nee |  |
| `description` | varchar(500) |  | ja |  |
| `startDate` | date |  | nee |  |
| `launchDeadline` | date |  | nee |  |
| `status` | varchar(30) |  | nee |  |

#### Milestone

Mijlpaal binnen een ontwikkelproject.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `milestoneID` | integer | PK | nee |  |
| `developmentProjectID` | integer | FK → DevelopmentProject | nee |  |
| `name` | varchar(120) |  | nee |  |
| `description` | varchar(500) |  | ja |  |
| `deadline` | date |  | nee |  |
| `status` | varchar(30) |  | nee |  |

#### Task

Taak binnen een ontwikkelproject.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `taskID` | integer | PK | nee |  |
| `developmentProjectID` | integer | FK → DevelopmentProject | nee |  |
| `employeeID` | integer | FK → Employee | ja | Toegewezen aan |
| `title` | varchar(150) |  | nee |  |
| `description` | varchar(500) |  | ja |  |
| `deadline` | date |  | nee |  |
| `status` | varchar(30) |  | nee |  |

#### ProjectTravelComponent

Koppeltabel project ↔ onderzocht reisonderdeel.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `developmentProjectID` | integer | PK, FK → DevelopmentProject | nee |  |
| `travelComponentID` | integer | PK, FK → TravelComponent | nee |  |

#### PurchaseInvoice

Inkoopfactuur van een leverancier.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `purchaseInvoiceID` | integer | PK | nee |  |
| `supplierID` | integer | FK → Supplier, U | nee |  |
| `invoiceNumber` | varchar(50) | U | nee | Factuurnummer van de leverancier |
| `invoiceDate` | date |  | nee |  |
| `dueDate` | date |  | nee |  |
| `totalAmount` | numeric(12,2) |  | nee |  |
| `vatAmount` | numeric(12,2) |  | nee |  |
| `status` | varchar(30) |  | nee |  |

#### PurchaseInvoiceLine

Regel van een inkoopfactuur.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `purchaseInvoiceID` | integer | PK, FK → PurchaseInvoice | nee |  |
| `lineNumber` | smallint | PK | nee |  |
| `offerID` | integer | FK → ComponentOffer | nee |  |
| `quantity` | integer |  | nee |  |
| `pricePerUnit` | numeric(12,2) |  | nee |  |
| `vatPercentage` | numeric(5,2) |  | nee |  |

### Financiën & Administratie

#### Invoice

Verkoopfactuur aan de klant.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `invoiceID` | integer | PK | nee |  |
| `bookingID` | integer | FK → Booking | nee |  |
| `invoiceNumber` | varchar(60) | U | nee |  |
| `invoiceDate` | date |  | nee |  |
| `dueDate` | date |  | nee |  |
| `amount` | numeric(12,2) |  | nee |  |
| `currency` | char(3) |  | nee |  |
| `status` | varchar(30) |  | nee |  |

#### PaymentMethod

Betaalmethode: iDEAL, creditcard, Klarna, ...

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `paymentMethodID` | integer | PK | nee |  |
| `code` | varchar(20) | U | nee |  |
| `description` | varchar(50) |  | nee |  |

#### Payment

Ontvangen betaling op een factuur.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `paymentID` | integer | PK | nee |  |
| `invoiceID` | integer | FK → Invoice | nee |  |
| `paymentMethodID` | integer | FK → PaymentMethod | ja |  |
| `paidAt` | timestamp |  | nee |  |
| `amount` | numeric(12,2) |  | nee |  |
| `transactionReference` | varchar(100) | U | ja | Referentie PSP/bank |
| `status` | varchar(30) |  | nee |  |

#### PaymentReminder

Betalingsherinnering (automatisch verstuurd).

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `reminderID` | integer | PK | nee |  |
| `invoiceID` | integer | FK → Invoice | nee |  |
| `channelID` | integer | FK → CommunicationChannel | nee |  |
| `sentAt` | timestamp |  | nee |  |
| `level` | smallint |  | nee | 1e, 2e, 3e herinnering |

#### Refund

Terugbetaling na een annulering.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `refundID` | integer | PK | nee |  |
| `cancellationID` | integer | FK → Cancellation | nee |  |
| `paymentMethodID` | integer | FK → PaymentMethod | nee |  |
| `refundDate` | date |  | nee |  |
| `amount` | numeric(12,2) |  | nee |  |
| `status` | varchar(30) |  | nee |  |

#### LedgerAccount

Grootboekrekening.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `accountCode` | varchar(10) | PK | nee | Bijv. 8000 Omzet reizen |
| `name` | varchar(80) |  | nee |  |
| `accountType` | varchar(20) |  | nee | activa / passiva / kosten / opbrengsten |

#### JournalEntry

Journaalpost: financiële verantwoording van een boeking of inkoopfactuur.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `journalEntryID` | integer | PK | nee |  |
| `bookingID` | integer | FK → Booking | ja |  |
| `purchaseInvoiceID` | integer | FK → PurchaseInvoice | ja |  |
| `entryDate` | date |  | nee |  |
| `description` | varchar(255) |  | nee |  |
| `fiscalYear` | smallint |  | nee |  |

#### JournalEntryLine

Debet/credit-regel van een journaalpost.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `journalEntryID` | integer | PK, FK → JournalEntry | nee |  |
| `lineNumber` | smallint | PK | nee |  |
| `accountCode` | varchar(10) | FK → LedgerAccount | nee |  |
| `description` | varchar(255) |  | ja |  |
| `debitAmount` | numeric(12,2) |  | nee |  |
| `creditAmount` | numeric(12,2) |  | nee |  |

### IT & Innovatie

#### System

Applicatie/systeem in het landschap.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `systemID` | integer | PK | nee |  |
| `name` | varchar(100) | U | nee |  |
| `type` | varchar(50) |  | nee |  |
| `vendor` | varchar(100) |  | ja |  |
| `version` | varchar(30) |  | ja |  |
| `status` | varchar(30) |  | nee |  |
| `legacy` | boolean |  | nee |  |

#### Integration

Koppeling tussen twee systemen.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `integrationID` | integer | PK | nee |  |
| `sourceSystemID` | integer | FK → System | nee | Bronsysteem |
| `targetSystemID` | integer | FK → System | nee | Doelsysteem |
| `type` | varchar(30) |  | nee | API / batch / bestand |
| `status` | varchar(30) |  | nee |  |
| `lastSync` | timestamp |  | ja |  |

#### IntegrationError

Fout in een koppeling.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `integrationErrorID` | integer | PK | nee |  |
| `integrationID` | integer | FK → Integration | nee |  |
| `occurredAt` | timestamp |  | nee |  |
| `errorCode` | varchar(50) |  | ja |  |
| `description` | varchar(1000) |  | nee |  |
| `resolvedAt` | timestamp |  | ja |  |

#### ChangeRequest

Wijzigingsverzoek voor een systeem.

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `changeID` | integer | PK | nee |  |
| `systemID` | integer | FK → System | nee |  |
| `employeeID` | integer | FK → Employee | nee | Aanvrager |
| `title` | varchar(150) |  | nee |  |
| `description` | varchar(1000) |  | nee |  |
| `priority` | varchar(20) |  | nee |  |
| `status` | varchar(30) |  | nee |  |
| `createdAt` | timestamp |  | nee |  |
| `completedAt` | timestamp |  | ja |  |

#### AuditLog

Wie wijzigde wat, wanneer (betrouwbare data).

| Attribuut | Type | Sleutel | Leeg? | Omschrijving |
|---|---|---|---|---|
| `auditLogID` | integer | PK | nee |  |
| `systemID` | integer | FK → System | ja |  |
| `employeeID` | integer | FK → Employee | ja |  |
| `tableName` | varchar(80) |  | nee |  |
| `recordID` | varchar(50) |  | nee | Sleutel van het gewijzigde record |
| `action` | varchar(30) |  | nee | INSERT / UPDATE / DELETE |
| `oldValue` | varchar(1000) |  | ja |  |
| `newValue` | varchar(1000) |  | ja |  |
| `loggedAt` | timestamp |  | nee |  |
