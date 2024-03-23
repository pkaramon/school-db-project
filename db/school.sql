-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-01-22 01:26:42.791

-- tables
-- Table: CartHistory
CREATE TABLE CartHistory (
    CartHistoryID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    ProductID int  NOT NULL,
    AddedAt datetime  NOT NULL,
    RemovedAt datetime  NOT NULL,
    CONSTRAINT CartHistory_AddedAt CHECK (AddedAt <= GetDate()),
    CONSTRAINT CartHIstory_RemovedAt CHECK (RemovedAt >= AddedAt AND RemovedAt <= GetDate()),
    CONSTRAINT CartHistory_pk PRIMARY KEY  (CartHistoryID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CartHistory', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'CartHistory';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela CartHistory przechowuje historię zmian w koszyku zakupowym.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'CartHistory';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CartHistory', 'COLUMN','CartHistoryID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CartHistory',
          @level2type = N'COLUMN',
          @level2name = 'CartHistoryID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator historii koszyka.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CartHistory',
     @level2type = N'COLUMN',
     @level2name = 'CartHistoryID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CartHistory', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CartHistory',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator użytkownika, do którego przypisana jest historia koszyka.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CartHistory',
     @level2type = N'COLUMN',
     @level2name = 'UserID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CartHistory', 'COLUMN','ProductID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CartHistory',
          @level2type = N'COLUMN',
          @level2name = 'ProductID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator produktu, który był dodany do koszyka.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CartHistory',
     @level2type = N'COLUMN',
     @level2name = 'ProductID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CartHistory', 'COLUMN','AddedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CartHistory',
          @level2type = N'COLUMN',
          @level2name = 'AddedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data dodania produktu do koszyka.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CartHistory',
     @level2type = N'COLUMN',
     @level2name = 'AddedAt';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CartHistory', 'COLUMN','RemovedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CartHistory',
          @level2type = N'COLUMN',
          @level2name = 'RemovedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data usunięcia produktu z koszyka.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CartHistory',
     @level2type = N'COLUMN',
     @level2name = 'RemovedAt';

-- Table: Carts
CREATE TABLE Carts (
    UserID int  NOT NULL,
    ProductID int  NOT NULL,
    AddedAt datetime  NOT NULL DEFAULT GEtDATE(),
    CONSTRAINT Carts_AddedAtIsValid CHECK (AddedAt <= GetDate()),
    CONSTRAINT Carts_pk PRIMARY KEY  (UserID,ProductID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Carts', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Carts';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Carts przechowuje informacje o koszykach zakupowych użytkowników.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Carts';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Carts', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Carts',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator użytkownika, do którego przypisany jest koszyk.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Carts',
     @level2type = N'COLUMN',
     @level2name = 'UserID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Carts', 'COLUMN','ProductID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Carts',
          @level2type = N'COLUMN',
          @level2name = 'ProductID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator produktu, który został dodany do koszyka.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Carts',
     @level2type = N'COLUMN',
     @level2name = 'ProductID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Carts', 'COLUMN','AddedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Carts',
          @level2type = N'COLUMN',
          @level2name = 'AddedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data i godzina dodania produktu do koszyka. Wartość domyślna to bieżąca data i czas.     ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Carts',
     @level2type = N'COLUMN',
     @level2name = 'AddedAt';

-- Table: CourseOfflineSessions
CREATE TABLE CourseOfflineSessions (
    CourseOfflineSessionID int  NOT NULL,
    Link nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    UploadedAt datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CourseOfflineSessions_UploadedAtIsValid CHECK (UploadedAt <= GETDATE() ),
    CONSTRAINT CourseOfflineSessions_pk PRIMARY KEY  (CourseOfflineSessionID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOfflineSessions', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'CourseOfflineSessions';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela CourseOfflineSessions przechowuje informacje o sesjach kursów offline.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'CourseOfflineSessions';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOfflineSessions', 'COLUMN','CourseOfflineSessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOfflineSessions',
          @level2type = N'COLUMN',
          @level2name = 'CourseOfflineSessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator sesji kursu offline.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOfflineSessions',
     @level2type = N'COLUMN',
     @level2name = 'CourseOfflineSessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOfflineSessions', 'COLUMN','Link'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOfflineSessions',
          @level2type = N'COLUMN',
          @level2name = 'Link';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Łącze do sesji kursu offline.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOfflineSessions',
     @level2type = N'COLUMN',
     @level2name = 'Link';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOfflineSessions', 'COLUMN','Description'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOfflineSessions',
          @level2type = N'COLUMN',
          @level2name = 'Description';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis sesji kursu offline, zawierający informacje na temat treści i celów.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOfflineSessions',
     @level2type = N'COLUMN',
     @level2name = 'Description';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOfflineSessions', 'COLUMN','UploadedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOfflineSessions',
          @level2type = N'COLUMN',
          @level2name = 'UploadedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data przesłania informacji o sesji, domyślnie ustawiana na bieżącą datę. Ograniczenie CHECK (UploadedAt <= GETDATE()) zapewnia, że data przesyłania nie może być późniejsza niż bieżąca data.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOfflineSessions',
     @level2type = N'COLUMN',
     @level2name = 'UploadedAt';

-- Table: CourseOnlineSessions
CREATE TABLE CourseOnlineSessions (
    CourseOnlineSessionID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    WebinarLink nvarchar(max)  NOT NULL,
    RecordingLink nvarchar(max)  NULL,
    CONSTRAINT CourseOnlineSessions_DateIntervalCheck CHECK (StartDate < EndDate),
    CONSTRAINT CourseOnlineSessions_pk PRIMARY KEY  (CourseOnlineSessionID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOnlineSessions', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'CourseOnlineSessions';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela CourseOnlineSessions przechowuje informacje o sesjach kursów online.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'CourseOnlineSessions';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOnlineSessions', 'COLUMN','CourseOnlineSessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOnlineSessions',
          @level2type = N'COLUMN',
          @level2name = 'CourseOnlineSessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator sesji kursu online.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOnlineSessions',
     @level2type = N'COLUMN',
     @level2name = 'CourseOnlineSessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOnlineSessions', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOnlineSessions',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia sesji kursu online.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOnlineSessions',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOnlineSessions', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOnlineSessions',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia sesji kursu online.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOnlineSessions',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOnlineSessions', 'COLUMN','WebinarLink'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOnlineSessions',
          @level2type = N'COLUMN',
          @level2name = 'WebinarLink';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Link do platformy webinarowej, na której odbywa się sesja kursu online.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOnlineSessions',
     @level2type = N'COLUMN',
     @level2name = 'WebinarLink';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseOnlineSessions', 'COLUMN','RecordingLink'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseOnlineSessions',
          @level2type = N'COLUMN',
          @level2name = 'RecordingLink';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Link do nagrania sesji kursu online. Może być NULL w przypadku braku dostępnego nagrania.  ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseOnlineSessions',
     @level2type = N'COLUMN',
     @level2name = 'RecordingLink';

-- Table: CourseParticipants
CREATE TABLE CourseParticipants (
    CourseParticipantID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    CourseID int  NOT NULL,
    CoursePrice money  NOT NULL,
    EntryFee money  NOT NULL,
    EntryFeePaymentID int  NULL,
    RemainingPaymentID int  NULL,
    FullPricePaymentID int  NULL,
    DuePostponedPayment datetime  NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    Completed bit  NOT NULL,
    CONSTRAINT CourseParticipants_PriceCheck CHECK (CoursePrice >= 0),
    CONSTRAINT CourseParticpants_EntryFeeCheck CHECK (EntryFee >= 0 and EntryFee <= CoursePrice),
    CONSTRAINT CourseParticipants_pk PRIMARY KEY  (CourseParticipantID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'CourseParticipants';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela CourseParticipants przechowuje informacje o uczestnikach kursów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'CourseParticipants';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','CourseParticipantID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'CourseParticipantID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator uczestnika kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'CourseParticipantID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator użytkownika, który jest jednocześnie kluczem obcym powiązanym z tabelą Users.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'UserID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','CourseID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'CourseID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator kursu, który jest jednocześnie kluczem obcym powiązanym z tabelą Courses.    ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'CourseID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','CoursePrice'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'CoursePrice';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Cena kursu dla uczestnika.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'CoursePrice';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','EntryFee'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'EntryFee';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Cena zaliczki dla tego kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'EntryFee';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','EntryFeePaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'EntryFeePaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator płatności za zaliczkę, który jest jednocześnie kluczem obcym powiązanym z tabelą Payments.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'EntryFeePaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','RemainingPaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'RemainingPaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator pozostałej płatności, który jest jednocześnie kluczem obcym powiązanym z tabelą Payments.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'RemainingPaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','FullPricePaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'FullPricePaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator pełnej płatności, który jest jednocześnie kluczem obcym powiązanym z tabelą Payments.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'FullPricePaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','DuePostponedPayment'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'DuePostponedPayment';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data, do której została odroczona płatność.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'DuePostponedPayment';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','AddedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'AddedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data dodania uczestnika do kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'AddedAt';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseParticipants', 'COLUMN','Completed'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseParticipants',
          @level2type = N'COLUMN',
          @level2name = 'Completed';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Wartość logiczna określająca, czy uczestnik ukończył kurs (1 - ukończono, 0 - nie ukończono).',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseParticipants',
     @level2type = N'COLUMN',
     @level2name = 'Completed';

-- Table: CourseSessionsAttendance
CREATE TABLE CourseSessionsAttendance (
    CourseParticipantID int  NOT NULL,
    CourseSessionID int  NOT NULL,
    Completed bit  NOT NULL,
    CONSTRAINT CourseSessionsAttendance_pk PRIMARY KEY  (CourseSessionID,CourseParticipantID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseSessionsAttendance', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'CourseSessionsAttendance';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela CourseSessionsAttendance przechowuje informacje o uczestnictwie w sesjach kursu.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'CourseSessionsAttendance';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseSessionsAttendance', 'COLUMN','CourseParticipantID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseSessionsAttendance',
          @level2type = N'COLUMN',
          @level2name = 'CourseParticipantID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator uczestnika kursu, który jest jednocześnie kluczem obcym powiązanym z tabelą CourseParticipants.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseSessionsAttendance',
     @level2type = N'COLUMN',
     @level2name = 'CourseParticipantID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseSessionsAttendance', 'COLUMN','CourseSessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseSessionsAttendance',
          @level2type = N'COLUMN',
          @level2name = 'CourseSessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator sesji kursu, który jest jednocześnie kluczem obcym powiązanym z tabelą CourseSessions.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseSessionsAttendance',
     @level2type = N'COLUMN',
     @level2name = 'CourseSessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseSessionsAttendance', 'COLUMN','Completed'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseSessionsAttendance',
          @level2type = N'COLUMN',
          @level2name = 'Completed';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Wartość logiczna określająca, czy uczestnik ukończył daną sesję kursu (1 - ukończono, 0 - nie ukończono).',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseSessionsAttendance',
     @level2type = N'COLUMN',
     @level2name = 'Completed';

-- Table: CourseStationarySessions
CREATE TABLE CourseStationarySessions (
    CourseStationarySessionID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    PostalCode nvarchar(20)  NOT NULL,
    ClassroomNumber nvarchar(30)  NOT NULL,
    MaxStudents int  NOT NULL,
    CONSTRAINT CourseStationarySessions_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT CourseStationarySessions_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CourseStationarySessions_MaxStudentsIValid CHECK (MaxStudents > 0),
    CONSTRAINT CourseStationarySessions_pk PRIMARY KEY  (CourseStationarySessionID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'CourseStationarySessions';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela CourseStationarySessions przechowuje informacje o sesjach stacjonarnych kursów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'CourseStationarySessions';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','CourseStationarySessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'CourseStationarySessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator sesji stacjonarnej kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'CourseStationarySessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data i godzina rozpoczęcia sesji stacjonarnej.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data i godzina zakończenia sesji stacjonarnej.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','Address'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'Address';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Adres, na którym odbywa się sesja stacjonarna.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'Address';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','City'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'City';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Miasto, w którym odbywa się sesja stacjonarna.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'City';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','Country'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'Country';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kraj, w którym odbywa się sesja stacjonarna.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'Country';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','PostalCode'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'PostalCode';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kod pocztowy sesji stacjonarnej, spełniający warunki poprawności.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'PostalCode';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','ClassroomNumber'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'ClassroomNumber';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Numer sali, w której odbywa się sesja stacjonarna.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'ClassroomNumber';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CourseStationarySessions', 'COLUMN','MaxStudents'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CourseStationarySessions',
          @level2type = N'COLUMN',
          @level2name = 'MaxStudents';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Maksymalna liczba studentów, którzy mogą uczestniczyć w sesji stacjonarnej.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CourseStationarySessions',
     @level2type = N'COLUMN',
     @level2name = 'MaxStudents';

-- Table: Courses
CREATE TABLE Courses (
    CourseID int  NOT NULL,
    CourseName nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    CoordinatorID int  NOT NULL,
    MaxStudents int  NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT Course_MaxStudents CHECK (MaxStudents is NULL OR (MaxStudents > 0) ),
    CONSTRAINT Course_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Courses';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Courses przechowuje informacje o kursach dostępnych w systemie.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Courses';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', 'COLUMN','CourseID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Courses',
          @level2type = N'COLUMN',
          @level2name = 'CourseID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Courses',
     @level2type = N'COLUMN',
     @level2name = 'CourseID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', 'COLUMN','CourseName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Courses',
          @level2type = N'COLUMN',
          @level2name = 'CourseName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Courses',
     @level2type = N'COLUMN',
     @level2name = 'CourseName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', 'COLUMN','Description'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Courses',
          @level2type = N'COLUMN',
          @level2name = 'Description';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis kursu, zawierający informacje dotyczące treści i celów.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Courses',
     @level2type = N'COLUMN',
     @level2name = 'Description';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Courses',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Courses',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Courses',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia kursu.
',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Courses',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', 'COLUMN','CoordinatorID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Courses',
          @level2type = N'COLUMN',
          @level2name = 'CoordinatorID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator koordynatora kursu, który jest pracownikiem systemu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Courses',
     @level2type = N'COLUMN',
     @level2name = 'CoordinatorID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', 'COLUMN','MaxStudents'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Courses',
          @level2type = N'COLUMN',
          @level2name = 'MaxStudents';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Maksymalna liczba studentów, którzy mogą uczestniczyć w kursie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Courses',
     @level2type = N'COLUMN',
     @level2name = 'MaxStudents';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Courses', 'COLUMN','LanguageID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Courses',
          @level2type = N'COLUMN',
          @level2name = 'LanguageID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator języka, w jakim prowadzony jest kurs.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Courses',
     @level2type = N'COLUMN',
     @level2name = 'LanguageID';

-- Table: CoursesSessions
CREATE TABLE CoursesSessions (
    CourseSessionID int  NOT NULL IDENTITY,
    LanguageID int  NOT NULL,
    ModuleID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NULL,
    CONSTRAINT CoursesSessions_pk PRIMARY KEY  (CourseSessionID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CoursesSessions', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'CoursesSessions';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela CoursesSessions przechowuje informacje o sesjach kursów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'CoursesSessions';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CoursesSessions', 'COLUMN','CourseSessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CoursesSessions',
          @level2type = N'COLUMN',
          @level2name = 'CourseSessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator sesji kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CoursesSessions',
     @level2type = N'COLUMN',
     @level2name = 'CourseSessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CoursesSessions', 'COLUMN','LanguageID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CoursesSessions',
          @level2type = N'COLUMN',
          @level2name = 'LanguageID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Klucz obcy określający język, w jakim odbywa się sesja kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CoursesSessions',
     @level2type = N'COLUMN',
     @level2name = 'LanguageID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CoursesSessions', 'COLUMN','ModuleID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CoursesSessions',
          @level2type = N'COLUMN',
          @level2name = 'ModuleID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Klucz obcy wskazujący na moduł związany z daną sesją kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CoursesSessions',
     @level2type = N'COLUMN',
     @level2name = 'ModuleID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CoursesSessions', 'COLUMN','LecturerID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CoursesSessions',
          @level2type = N'COLUMN',
          @level2name = 'LecturerID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Klucz obcy wskazujący na wykładowcę prowadzącego daną sesję kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CoursesSessions',
     @level2type = N'COLUMN',
     @level2name = 'LecturerID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'CoursesSessions', 'COLUMN','TranslatorID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'CoursesSessions',
          @level2type = N'COLUMN',
          @level2name = 'TranslatorID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opcjonalny klucz obcy wskazujący na tłumacza przypisanego do sesji kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'CoursesSessions',
     @level2type = N'COLUMN',
     @level2name = 'TranslatorID';

-- Table: DaysInInternship
CREATE TABLE DaysInInternship (
    DaysInInternshipID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    InternshipID int  NULL,
    CONSTRAINT DaysInInternship_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT DaysInInternship_NumberOfDaysIsValid CHECK (NumberOfDays > 0),
    CONSTRAINT DaysInInternship_pk PRIMARY KEY  (DaysInInternshipID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DaysInInternship', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'DaysInInternship';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela DaysInInternship przechowuje informacje o czasie trwania stażu.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'DaysInInternship';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DaysInInternship', 'COLUMN','DaysInInternshipID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DaysInInternship',
          @level2type = N'COLUMN',
          @level2name = 'DaysInInternshipID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator czasu trwania dla stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DaysInInternship',
     @level2type = N'COLUMN',
     @level2name = 'DaysInInternshipID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DaysInInternship', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DaysInInternship',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Dzień rozpoczęcia stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DaysInInternship',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DaysInInternship', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DaysInInternship',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Dzień zakończenia stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DaysInInternship',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DaysInInternship', 'COLUMN','NumberOfDays'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DaysInInternship',
          @level2type = N'COLUMN',
          @level2name = 'NumberOfDays';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Czas trwania stażu (w dniach)',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DaysInInternship',
     @level2type = N'COLUMN',
     @level2name = 'NumberOfDays';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DaysInInternship', 'COLUMN','InternshipID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DaysInInternship',
          @level2type = N'COLUMN',
          @level2name = 'InternshipID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DaysInInternship',
     @level2type = N'COLUMN',
     @level2name = 'InternshipID';

-- Table: DiplomasSent
CREATE TABLE DiplomasSent (
    DiplomaSentID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    SentAt datetime  NOT NULL DEFAULT GETDATE(),
    ProductID int  NOT NULL,
    DiplomaFile nvarchar(max)  NULL,
    CONSTRAINT DiplomasSent_pk PRIMARY KEY  (DiplomaSentID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DiplomasSent', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'DiplomasSent';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela DiplomasSent przechowuje informacje o wysłanych dyplomach.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'DiplomasSent';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DiplomasSent', 'COLUMN','DiplomaSentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DiplomasSent',
          @level2type = N'COLUMN',
          @level2name = 'DiplomaSentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator wysłanego dyplomu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DiplomasSent',
     @level2type = N'COLUMN',
     @level2name = 'DiplomaSentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DiplomasSent', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DiplomasSent',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator użytkownika, któremu dyplom został wysłany.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DiplomasSent',
     @level2type = N'COLUMN',
     @level2name = 'UserID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DiplomasSent', 'COLUMN','SentAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DiplomasSent',
          @level2type = N'COLUMN',
          @level2name = 'SentAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data wysłania dyplomu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DiplomasSent',
     @level2type = N'COLUMN',
     @level2name = 'SentAt';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DiplomasSent', 'COLUMN','ProductID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DiplomasSent',
          @level2type = N'COLUMN',
          @level2name = 'ProductID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator produktu związanego z dyplomem.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DiplomasSent',
     @level2type = N'COLUMN',
     @level2name = 'ProductID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'DiplomasSent', 'COLUMN','DiplomaFile'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'DiplomasSent',
          @level2type = N'COLUMN',
          @level2name = 'DiplomaFile';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Ścieżka do pliku dyplomu, jeżeli został załączony.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'DiplomasSent',
     @level2type = N'COLUMN',
     @level2name = 'DiplomaFile';

-- Table: EmployeeRoles
CREATE TABLE EmployeeRoles (
    EmployeeRoleEntryID int  NOT NULL IDENTITY,
    EmployeeID int  NOT NULL,
    RoleID int  NOT NULL,
    CONSTRAINT EmployeeRoles_ak_1 UNIQUE (EmployeeRoleEntryID, RoleID),
    CONSTRAINT EmployeeRoles_pk PRIMARY KEY  (EmployeeRoleEntryID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'EmployeeRoles', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'EmployeeRoles';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela EmployeeRoles przechowuje informacje o rolach przypisanych pracownikom systemu.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'EmployeeRoles';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'EmployeeRoles', 'COLUMN','EmployeeRoleEntryID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'EmployeeRoles',
          @level2type = N'COLUMN',
          @level2name = 'EmployeeRoleEntryID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator wpisu roli pracownika, który jest generowany automatycznie.       ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'EmployeeRoles',
     @level2type = N'COLUMN',
     @level2name = 'EmployeeRoleEntryID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'EmployeeRoles', 'COLUMN','EmployeeID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'EmployeeRoles',
          @level2type = N'COLUMN',
          @level2name = 'EmployeeID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator pracownika, do którego przypisana jest rola. Jest to klucz obcy, odnoszący 
się do kolumny EmployeeID w tabeli Employees.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'EmployeeRoles',
     @level2type = N'COLUMN',
     @level2name = 'EmployeeID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'EmployeeRoles', 'COLUMN','RoleID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'EmployeeRoles',
          @level2type = N'COLUMN',
          @level2name = 'RoleID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator roli przypisanej pracownikowi. Jest to klucz obcy, odnoszący się do kolumny RoleID w tabeli Roles.
',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'EmployeeRoles',
     @level2type = N'COLUMN',
     @level2name = 'RoleID';

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID int  NOT NULL,
    HireDate date  NOT NULL,
    IsActive bit  NOT NULL,
    CONSTRAINT id PRIMARY KEY  (EmployeeID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Employees', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Employees';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Employees przechowuje informacje o pracownikach systemu.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Employees';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Employees', 'COLUMN','EmployeeID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Employees',
          @level2type = N'COLUMN',
          @level2name = 'EmployeeID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator pracownika, stanowiący klucz główny tabeli.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Employees',
     @level2type = N'COLUMN',
     @level2name = 'EmployeeID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Employees', 'COLUMN','HireDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Employees',
          @level2type = N'COLUMN',
          @level2name = 'HireDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zatrudnienia pracownika.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Employees',
     @level2type = N'COLUMN',
     @level2name = 'HireDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Employees', 'COLUMN','IsActive'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Employees',
          @level2type = N'COLUMN',
          @level2name = 'IsActive';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Flaga określająca, czy pracownik jest aktualnie zatrudniony.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Employees',
     @level2type = N'COLUMN',
     @level2name = 'IsActive';

-- Table: Exams
CREATE TABLE Exams (
    ExamID int  NOT NULL IDENTITY,
    SubjectID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    PostalCode nvarchar(500)  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    CONSTRAINT Exams_DateInteralIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Exams_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT Exams_pk PRIMARY KEY  (ExamID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Exams';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Exams przechowuje informacje o egzaminach.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Exams';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', 'COLUMN','ExamID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Exams',
          @level2type = N'COLUMN',
          @level2name = 'ExamID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator egzaminu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Exams',
     @level2type = N'COLUMN',
     @level2name = 'ExamID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', 'COLUMN','SubjectID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Exams',
          @level2type = N'COLUMN',
          @level2name = 'SubjectID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator przedmiotu, do którego przeprowadzany jest egzamin',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Exams',
     @level2type = N'COLUMN',
     @level2name = 'SubjectID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Exams',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia egzaminu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Exams',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Exams',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia egzaminu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Exams',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', 'COLUMN','Country'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Exams',
          @level2type = N'COLUMN',
          @level2name = 'Country';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa państwa, w którym przeprowadzany jest egzamin',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Exams',
     @level2type = N'COLUMN',
     @level2name = 'Country';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', 'COLUMN','City'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Exams',
          @level2type = N'COLUMN',
          @level2name = 'City';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa miasta, w którym przeprowadzany jest egzamin',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Exams',
     @level2type = N'COLUMN',
     @level2name = 'City';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', 'COLUMN','PostalCode'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Exams',
          @level2type = N'COLUMN',
          @level2name = 'PostalCode';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kod pocztowy adresu, w którym przeprowadzany jest egzamin',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Exams',
     @level2type = N'COLUMN',
     @level2name = 'PostalCode';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Exams', 'COLUMN','Address'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Exams',
          @level2type = N'COLUMN',
          @level2name = 'Address';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Dokładny adres przeprowadzania egzaminu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Exams',
     @level2type = N'COLUMN',
     @level2name = 'Address';

-- Table: ExamsGrades
CREATE TABLE ExamsGrades (
    StudentID int  NOT NULL,
    ExamID int  NOT NULL,
    FinalGrade decimal(2,1)  NOT NULL,
    CONSTRAINT FinalExams_FinalGradeIsValid CHECK (FinalGrade IN (2.0, 3.0, 3.5, 4.0, 4.5, 5.0)),
    CONSTRAINT ExamsGrades_pk PRIMARY KEY  (StudentID,ExamID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ExamsGrades', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'ExamsGrades';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela ExamGrades przechowuje informacje o ocenach z przeprowadzonych egzaminów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'ExamsGrades';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ExamsGrades', 'COLUMN','StudentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ExamsGrades',
          @level2type = N'COLUMN',
          @level2name = 'StudentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator egzaminowanego studenta',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ExamsGrades',
     @level2type = N'COLUMN',
     @level2name = 'StudentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ExamsGrades', 'COLUMN','ExamID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ExamsGrades',
          @level2type = N'COLUMN',
          @level2name = 'ExamID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator egzaminu, w którym student brał udział',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ExamsGrades',
     @level2type = N'COLUMN',
     @level2name = 'ExamID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ExamsGrades', 'COLUMN','FinalGrade'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ExamsGrades',
          @level2type = N'COLUMN',
          @level2name = 'FinalGrade';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Ocena końcowa uzyskana przez studenta z egzaminu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ExamsGrades',
     @level2type = N'COLUMN',
     @level2name = 'FinalGrade';

-- Table: FieldsOfStudies
CREATE TABLE FieldsOfStudies (
    FieldOfStudiesID int  NOT NULL IDENTITY,
    Name nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CONSTRAINT FieldsOfStudies_pk PRIMARY KEY  (FieldOfStudiesID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'FieldsOfStudies', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'FieldsOfStudies';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela FieldsOfStudies przechowuje informacje o wszystkich dziedzinach oferowanych studiów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'FieldsOfStudies';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'FieldsOfStudies', 'COLUMN','FieldOfStudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'FieldsOfStudies',
          @level2type = N'COLUMN',
          @level2name = 'FieldOfStudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator dziedziny studiów.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'FieldsOfStudies',
     @level2type = N'COLUMN',
     @level2name = 'FieldOfStudiesID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'FieldsOfStudies', 'COLUMN','Name'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'FieldsOfStudies',
          @level2type = N'COLUMN',
          @level2name = 'Name';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa dziedziny studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'FieldsOfStudies',
     @level2type = N'COLUMN',
     @level2name = 'Name';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'FieldsOfStudies', 'COLUMN','Description'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'FieldsOfStudies',
          @level2type = N'COLUMN',
          @level2name = 'Description';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis dziedziny studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'FieldsOfStudies',
     @level2type = N'COLUMN',
     @level2name = 'Description';

-- Table: InternshipDetails
CREATE TABLE InternshipDetails (
    StudentID int  NOT NULL,
    IntershipID int  NOT NULL,
    CompletedAt date  NULL,
    Completed bit  NOT NULL,
    CompanyName nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    PostalCode nvarchar(500)  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    CONSTRAINT InternshipDetails_CompletedAtIsValid CHECK (CompletedAt <= GetDate()),
    CONSTRAINT InternshipDetails_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT InternshipDetails_pk PRIMARY KEY  (IntershipID,StudentID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'InternshipDetails';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela InternshipDetails przechowuje informacje na temat przebiegu stażu dla każdego studenta.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'InternshipDetails';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','StudentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'StudentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID studenta',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'StudentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','IntershipID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'IntershipID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'IntershipID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','CompletedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'CompletedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zaliczenia stażu, w przypadku gdy student go zaliczył',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'CompletedAt';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','Completed'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'Completed';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Oznaczenie, czy student zaliczył staż',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'Completed';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','CompanyName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'CompanyName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa firmy oferującej staż',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'CompanyName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','City'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'City';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa miasta, w którym zlokalizowana jest firma oferująca staż',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'City';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','Country'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'Country';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa państwa, w którym zlokalizowana jest firma oferująca staż',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'Country';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','PostalCode'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'PostalCode';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kod pocztowy do adresu, w którym zlokalizowana jest firma oferująca staż',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'PostalCode';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'InternshipDetails', 'COLUMN','Address'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'InternshipDetails',
          @level2type = N'COLUMN',
          @level2name = 'Address';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Adres firmy oferującej staż',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'InternshipDetails',
     @level2type = N'COLUMN',
     @level2name = 'Address';

-- Table: Internships
CREATE TABLE Internships (
    InternshipID int  NOT NULL IDENTITY,
    StudiesID int  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    CONSTRAINT Internships_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Internships', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Internships';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Internships przechowuje informacje o wszystkich oferowanych programach stażowych.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Internships';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Internships', 'COLUMN','InternshipID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Internships',
          @level2type = N'COLUMN',
          @level2name = 'InternshipID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator programu stażowego.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Internships',
     @level2type = N'COLUMN',
     @level2name = 'InternshipID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Internships', 'COLUMN','StudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Internships',
          @level2type = N'COLUMN',
          @level2name = 'StudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID studiów, do których przypisany jest program stażowy',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Internships',
     @level2type = N'COLUMN',
     @level2name = 'StudiesID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Internships', 'COLUMN','Description'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Internships',
          @level2type = N'COLUMN',
          @level2name = 'Description';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Internships',
     @level2type = N'COLUMN',
     @level2name = 'Description';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Internships', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Internships',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Internships',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Internships', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Internships',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Internships',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';

-- Table: Languages
CREATE TABLE Languages (
    LanguageID int  NOT NULL IDENTITY,
    LanguageName nvarchar(200)  NOT NULL,
    CONSTRAINT LanguageName UNIQUE (LanguageName),
    CONSTRAINT Languages_pk PRIMARY KEY  (LanguageID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Languages', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Languages';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Languages przechowuje informacje o dostępnych językach w systemie.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Languages';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Languages', 'COLUMN','LanguageID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Languages',
          @level2type = N'COLUMN',
          @level2name = 'LanguageID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator języka, generowany automatycznie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Languages',
     @level2type = N'COLUMN',
     @level2name = 'LanguageID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Languages', 'COLUMN','LanguageName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Languages',
          @level2type = N'COLUMN',
          @level2name = 'LanguageName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa języka, opisująca konkretny język używany w systemie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Languages',
     @level2type = N'COLUMN',
     @level2name = 'LanguageName';

-- Table: MadeUpAttendance
CREATE TABLE MadeUpAttendance (
    MadeUpAttendanceID int  NOT NULL IDENTITY,
    SubjectID int  NOT NULL,
    ProductID int  NOT NULL,
    StudentID int  NOT NULL,
    CONSTRAINT MadeUpAttendance_ak_1 UNIQUE (SubjectID, ProductID, StudentID),
    CONSTRAINT MadeUpAttendance_pk PRIMARY KEY  (MadeUpAttendanceID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MadeUpAttendance', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'MadeUpAttendance';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'W tabeli MadeUpAttendance odnotowywane są wszystkie "zastępstwa" dla studentów zaliczających przedmiot innym produktem.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'MadeUpAttendance';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MadeUpAttendance', 'COLUMN','MadeUpAttendanceID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MadeUpAttendance',
          @level2type = N'COLUMN',
          @level2name = 'MadeUpAttendanceID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator zrealizowanego "zastępstwa"',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MadeUpAttendance',
     @level2type = N'COLUMN',
     @level2name = 'MadeUpAttendanceID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MadeUpAttendance', 'COLUMN','SubjectID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MadeUpAttendance',
          @level2type = N'COLUMN',
          @level2name = 'SubjectID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator przedmiotu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MadeUpAttendance',
     @level2type = N'COLUMN',
     @level2name = 'SubjectID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MadeUpAttendance', 'COLUMN','ProductID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MadeUpAttendance',
          @level2type = N'COLUMN',
          @level2name = 'ProductID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator produktu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MadeUpAttendance',
     @level2type = N'COLUMN',
     @level2name = 'ProductID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MadeUpAttendance', 'COLUMN','StudentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MadeUpAttendance',
          @level2type = N'COLUMN',
          @level2name = 'StudentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID studenta zaliczającego przedmiot innym produktem',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MadeUpAttendance',
     @level2type = N'COLUMN',
     @level2name = 'StudentID';

-- Table: MaxDaysForPaymentBeforeCourseStart
CREATE TABLE MaxDaysForPaymentBeforeCourseStart (
    MaxDaysForPaymentBeforeCourseStartID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    CourseID int  NULL,
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_NumberOfDaysIValid CHECK (NumberOfDays > 0),
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_pk PRIMARY KEY  (MaxDaysForPaymentBeforeCourseStartID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeCourseStart', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'MaxDaysForPaymentBeforeCourseStart';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela MaxDaysForPaymentBeforeCourseStart przechowuje informacje dotyczące maksymalnej liczby dni, w jaką można dokonać płatności przed rozpoczęciem kursu.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'MaxDaysForPaymentBeforeCourseStart';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeCourseStart', 'COLUMN','MaxDaysForPaymentBeforeCourseStartID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeCourseStart',
          @level2type = N'COLUMN',
          @level2name = 'MaxDaysForPaymentBeforeCourseStartID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator określający maksymalną liczbę dni do dokonania płatności przed rozpoczęciem kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeCourseStart',
     @level2type = N'COLUMN',
     @level2name = 'MaxDaysForPaymentBeforeCourseStartID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeCourseStart', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeCourseStart',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia obowiązywania okresu, w którym można dokonać płatności przed rozpoczęciem kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeCourseStart',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeCourseStart', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeCourseStart',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opcjonalna data zakończenia obowiązywania okresu płatności przed rozpoczęciem kursu.     ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeCourseStart',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeCourseStart', 'COLUMN','NumberOfDays'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeCourseStart',
          @level2type = N'COLUMN',
          @level2name = 'NumberOfDays';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Maksymalna liczba dni, w jaką można dokonać płatności przed rozpoczęciem kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeCourseStart',
     @level2type = N'COLUMN',
     @level2name = 'NumberOfDays';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeCourseStart', 'COLUMN','CourseID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeCourseStart',
          @level2type = N'COLUMN',
          @level2name = 'CourseID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator kursu, do którego przypisane są informacje dotyczące maksymalnej liczby dni na dokonanie płatności przed rozpoczęciem kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeCourseStart',
     @level2type = N'COLUMN',
     @level2name = 'CourseID';

-- Table: MaxDaysForPaymentBeforeStudiesStart
CREATE TABLE MaxDaysForPaymentBeforeStudiesStart (
    MaxDaysForPaymentBeforeStudiesStartID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    StudiesID int  NULL,
    CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_DateIntervalIsValid CHECK (EndDate > StartDate),
    CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_NumberOfDaysIsValid CHECK (NumberOfDays > 0),
    CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_pk PRIMARY KEY  (MaxDaysForPaymentBeforeStudiesStartID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeStudiesStart', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'MaxDaysForPaymentBeforeStudiesStart';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela MaxDaysForPaymentBeforeStudiesStart przechowuje informacje o ostatecznych terminach spłaty studiów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'MaxDaysForPaymentBeforeStudiesStart';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeStudiesStart', 'COLUMN','MaxDaysForPaymentBeforeStudiesStartID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
          @level2type = N'COLUMN',
          @level2name = 'MaxDaysForPaymentBeforeStudiesStartID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator ostatecznego terminu spłaty',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
     @level2type = N'COLUMN',
     @level2name = 'MaxDaysForPaymentBeforeStudiesStartID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeStudiesStart', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia przyjmowania wpłat',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeStudiesStart', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakocaenia przyjmowania wpłat',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeStudiesStart', 'COLUMN','NumberOfDays'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
          @level2type = N'COLUMN',
          @level2name = 'NumberOfDays';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Liczba dni na spłatę studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
     @level2type = N'COLUMN',
     @level2name = 'NumberOfDays';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MaxDaysForPaymentBeforeStudiesStart', 'COLUMN','StudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
          @level2type = N'COLUMN',
          @level2name = 'StudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MaxDaysForPaymentBeforeStudiesStart',
     @level2type = N'COLUMN',
     @level2name = 'StudiesID';

-- Table: MinAttendancePercentageToPassCourse
CREATE TABLE MinAttendancePercentageToPassCourse (
    MinAttendancePercentageToPassCourseID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    AttendancePercentage decimal(6,4)  NOT NULL,
    CourseID int  NULL,
    CONSTRAINT MinAttendancePercentageToPassCourse_DateIntervalIsValid CHECK ((StartDate < EndDate)),
    CONSTRAINT MinAttendancePercentageToPassCourse_AttendencePercentageIsValid CHECK ((AttendancePercentage >= 0) and (AttendancePercentage <= 1)),
    CONSTRAINT MinAttendancePercentageToPassCourse_pk PRIMARY KEY  (MinAttendancePercentageToPassCourseID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassCourse', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'MinAttendancePercentageToPassCourse';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela MinAttendancePercentageToPassCourse przechowuje informacje dotyczące minimalnego procentowego udziału w zajęciach wymaganego do zaliczenia kursu.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'MinAttendancePercentageToPassCourse';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassCourse', 'COLUMN','MinAttendancePercentageToPassCourseID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassCourse',
          @level2type = N'COLUMN',
          @level2name = 'MinAttendancePercentageToPassCourseID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator minimalnego procentowego udziału w zajęciach wymaganego do zaliczenia kursu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassCourse',
     @level2type = N'COLUMN',
     @level2name = 'MinAttendancePercentageToPassCourseID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassCourse', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassCourse',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia okresu obowiązywania minimalnego procentowego udziału w zajęciach.      ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassCourse',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassCourse', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassCourse',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opcjonalna data zakończenia okresu obowiązywania minimalnego procentowego udziału w zajęciach.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassCourse',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassCourse', 'COLUMN','AttendancePercentage'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassCourse',
          @level2type = N'COLUMN',
          @level2name = 'AttendancePercentage';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Procentowy udział w zajęciach wymagany do zaliczenia kursu, wyrażony jako wartość dziesiętna.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassCourse',
     @level2type = N'COLUMN',
     @level2name = 'AttendancePercentage';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassCourse', 'COLUMN','CourseID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassCourse',
          @level2type = N'COLUMN',
          @level2name = 'CourseID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator kursu, do którego przypisane są wymagania dotyczące minimalnego procentowego udziału w zajęciach.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassCourse',
     @level2type = N'COLUMN',
     @level2name = 'CourseID';

-- Table: MinAttendancePercentageToPassInternship
CREATE TABLE MinAttendancePercentageToPassInternship (
    MinAttendancePercentageToPassInternshipID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    AttendancePercentage decimal(6,4)  NOT NULL,
    InternshipID int  NULL,
    CONSTRAINT MinAttendancePercentageToPassInternship_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MinAttendancePercentageToPassInternship_PercentageIsValid CHECK (AttendancePercentage BETWEEN 0 AND 1.0),
    CONSTRAINT MinAttendancePercentageToPassInternship_pk PRIMARY KEY  (MinAttendancePercentageToPassInternshipID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassInternship', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'MinAttendancePercentageToPassInternship';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela MinAttendancePercentageToPassInternship przechowuje informacje o minimalnej obecności potrzebnej do zaliczenia stażu.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'MinAttendancePercentageToPassInternship';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassInternship', 'COLUMN','MinAttendancePercentageToPassInternshipID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassInternship',
          @level2type = N'COLUMN',
          @level2name = 'MinAttendancePercentageToPassInternshipID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator procentu zaliczenia stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassInternship',
     @level2type = N'COLUMN',
     @level2name = 'MinAttendancePercentageToPassInternshipID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassInternship', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassInternship',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassInternship',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassInternship', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassInternship',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassInternship',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassInternship', 'COLUMN','AttendancePercentage'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassInternship',
          @level2type = N'COLUMN',
          @level2name = 'AttendancePercentage';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Minimalny procent obecności wymagany do zaliczenia stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassInternship',
     @level2type = N'COLUMN',
     @level2name = 'AttendancePercentage';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassInternship', 'COLUMN','InternshipID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassInternship',
          @level2type = N'COLUMN',
          @level2name = 'InternshipID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID stażu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassInternship',
     @level2type = N'COLUMN',
     @level2name = 'InternshipID';

-- Table: MinAttendancePercentageToPassStudies
CREATE TABLE MinAttendancePercentageToPassStudies (
    MinAttendancePercentageToPassStudiesID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    AttendancePercentage decimal(6,4)  NOT NULL,
    StudiesID int  NULL,
    CONSTRAINT MinAttendancePercentageToPassStudies_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MinAttendancePercentageToPassStudies_PercentageIsValid CHECK (AttendancePercentage BETWEEN 0 AND 1),
    CONSTRAINT MinAttendancePercentageToPassStudies_pk PRIMARY KEY  (MinAttendancePercentageToPassStudiesID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassStudies', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'MinAttendancePercentageToPassStudies';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela MinAttendancePercentageToPassStudies zawiera informacje o minimalnych wymaganiach dotyczących obecności na zajęciach dla każdego kierunku studiów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'MinAttendancePercentageToPassStudies';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassStudies', 'COLUMN','MinAttendancePercentageToPassStudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassStudies',
          @level2type = N'COLUMN',
          @level2name = 'MinAttendancePercentageToPassStudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator procentu zaliczenia studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassStudies',
     @level2type = N'COLUMN',
     @level2name = 'MinAttendancePercentageToPassStudiesID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassStudies', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassStudies',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassStudies',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassStudies', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassStudies',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassStudies',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassStudies', 'COLUMN','AttendancePercentage'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassStudies',
          @level2type = N'COLUMN',
          @level2name = 'AttendancePercentage';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Wymagany procent obecności na zajęciach',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassStudies',
     @level2type = N'COLUMN',
     @level2name = 'AttendancePercentage';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'MinAttendancePercentageToPassStudies', 'COLUMN','StudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'MinAttendancePercentageToPassStudies',
          @level2type = N'COLUMN',
          @level2name = 'StudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'MinAttendancePercentageToPassStudies',
     @level2type = N'COLUMN',
     @level2name = 'StudiesID';

-- Table: Modules
CREATE TABLE Modules (
    ModuleID int  NOT NULL IDENTITY,
    CourseID int  NOT NULL,
    ModuleName nvarchar(max)  NOT NULL,
    ModuleDescription nvarchar(max)  NOT NULL,
    CONSTRAINT Modules_pk PRIMARY KEY  (ModuleID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Modules', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Modules';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Modules przechowuje informacje o modułach składających się na kursy w systemie.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Modules';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Modules', 'COLUMN','ModuleID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Modules',
          @level2type = N'COLUMN',
          @level2name = 'ModuleID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator modułu, automatycznie generowany przez system.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Modules',
     @level2type = N'COLUMN',
     @level2name = 'ModuleID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Modules', 'COLUMN','CourseID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Modules',
          @level2type = N'COLUMN',
          @level2name = 'CourseID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator kursu, do którego przypisany jest moduł.      ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Modules',
     @level2type = N'COLUMN',
     @level2name = 'CourseID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Modules', 'COLUMN','ModuleName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Modules',
          @level2type = N'COLUMN',
          @level2name = 'ModuleName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa modułu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Modules',
     @level2type = N'COLUMN',
     @level2name = 'ModuleName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Modules', 'COLUMN','ModuleDescription'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Modules',
          @level2type = N'COLUMN',
          @level2name = 'ModuleDescription';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis modułu, zawierający szczegółowe informacje na temat treści i celów. ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Modules',
     @level2type = N'COLUMN',
     @level2name = 'ModuleDescription';

-- Table: OnlineStudiesSessions
CREATE TABLE OnlineStudiesSessions (
    OnlineStudiesSessionID int  NOT NULL,
    WebinarLink nvarchar(max)  NOT NULL,
    RecordingLink nvarchar(max)  NULL,
    CONSTRAINT OnlineStudiesSessions_pk PRIMARY KEY  (OnlineStudiesSessionID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'OnlineStudiesSessions', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'OnlineStudiesSessions';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela OnlineStudiesSessions przechowuje informacje o zajęciach odbywanych w formie zdalnej.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'OnlineStudiesSessions';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'OnlineStudiesSessions', 'COLUMN','OnlineStudiesSessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'OnlineStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'OnlineStudiesSessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator zajęć online',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'OnlineStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'OnlineStudiesSessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'OnlineStudiesSessions', 'COLUMN','WebinarLink'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'OnlineStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'WebinarLink';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Link do spotkania na żywo',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'OnlineStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'WebinarLink';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'OnlineStudiesSessions', 'COLUMN','RecordingLink'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'OnlineStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'RecordingLink';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Link do nagrania, w przypadku gdy spotkanie było nagrywane',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'OnlineStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'RecordingLink';

-- Table: Payments
CREATE TABLE Payments (
    PaymentID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    ProductID int  NOT NULL,
    Price money  NOT NULL,
    Date datetime  NOT NULL,
    Status nvarchar(300)  NOT NULL,
    CONSTRAINT Payments_Price CHECK (Price >= 0),
    CONSTRAINT Payments_Status CHECK (Status in ('Successful', 'Failed')),
    CONSTRAINT Payments_Date CHECK (Date <= GetDate()),
    CONSTRAINT Payments_pk PRIMARY KEY  (PaymentID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Payments', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Payments';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Payments przechowuje informacje o płatnościach dokonanych przez użytkowników.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Payments';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Payments', 'COLUMN','PaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Payments',
          @level2type = N'COLUMN',
          @level2name = 'PaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator płatności.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Payments',
     @level2type = N'COLUMN',
     @level2name = 'PaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Payments', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Payments',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator użytkownika, który dokonał płatności.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Payments',
     @level2type = N'COLUMN',
     @level2name = 'UserID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Payments', 'COLUMN','ProductID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Payments',
          @level2type = N'COLUMN',
          @level2name = 'ProductID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator produktu, na który użytkownik dokonał płatności.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Payments',
     @level2type = N'COLUMN',
     @level2name = 'ProductID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Payments', 'COLUMN','Price'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Payments',
          @level2type = N'COLUMN',
          @level2name = 'Price';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kwota płatności.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Payments',
     @level2type = N'COLUMN',
     @level2name = 'Price';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Payments', 'COLUMN','Date'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Payments',
          @level2type = N'COLUMN',
          @level2name = 'Date';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data dokonania płatności.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Payments',
     @level2type = N'COLUMN',
     @level2name = 'Date';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Payments', 'COLUMN','Status'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Payments',
          @level2type = N'COLUMN',
          @level2name = 'Status';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Status płatności "Successful" albo "Failed"',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Payments',
     @level2type = N'COLUMN',
     @level2name = 'Status';

-- Table: People
CREATE TABLE People (
    PersonID int  NOT NULL IDENTITY,
    FirstName nvarchar(max)  NOT NULL,
    LastName nvarchar(500)  NOT NULL,
    BirthDate date  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    Region nvarchar(500)  NOT NULL,
    PostalCode nvarchar(20)  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    Phone nvarchar(20)  NOT NULL,
    Email nvarchar(500)  NOT NULL,
    CONSTRAINT People_EmailValid CHECK (Email LIKE '%@%'),
    CONSTRAINT People_BirthDateValid CHECK (BirthDate <= GetDate()),
    CONSTRAINT People_PhoneIsValid CHECK ((ISNUMERIC([Phone])=(1))),
    CONSTRAINT People_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT Person_pk PRIMARY KEY  (PersonID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'People';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela People przechowuje informacje o osobach w systemie.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'People';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','PersonID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'PersonID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator osoby, generowany automatycznie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'PersonID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','FirstName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'FirstName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Imię osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'FirstName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','LastName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'LastName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwisko osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'LastName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','BirthDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'BirthDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data urodzenia osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'BirthDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','Address'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'Address';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Adres zamieszkania osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'Address';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','City'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'City';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Miasto zamieszkania osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'City';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','Region'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'Region';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Region zamieszkania osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'Region';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','PostalCode'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'PostalCode';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kod pocztowy zamieszkania osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'PostalCode';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','Country'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'Country';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kraj zamieszkania osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'Country';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','Phone'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'Phone';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Numer telefonu osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'Phone';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','Email'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'Email';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Adres e-mail osoby.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'Email';

-- Table: PeopleDataChangeHistory
CREATE TABLE PeopleDataChangeHistory (
    PersonDataChangeHistoryID int  NOT NULL IDENTITY,
    PersonID int  NOT NULL,
    ChangedAt datetime  NOT NULL,
    New_FirstName nvarchar(max)  NOT NULL,
    Old_FirstName nvarchar(max)  NOT NULL,
    New_LastName nvarchar(500)  NOT NULL,
    Old_LastName nvarchar(500)  NOT NULL,
    New_BirthDate date  NOT NULL,
    Old_BirthDate date  NOT NULL,
    New_Address nvarchar(500)  NOT NULL,
    Old_Address nvarchar(500)  NOT NULL,
    New_City nvarchar(500)  NOT NULL,
    Old_City nvarchar(500)  NOT NULL,
    New_Region nvarchar(500)  NOT NULL,
    Old_Region nvarchar(500)  NOT NULL,
    New_PostalCode nvarchar(20)  NOT NULL,
    Old_PostalCode nvarchar(500)  NOT NULL,
    New_Country nvarchar(500)  NOT NULL,
    Old_Country nvarchar(500)  NOT NULL,
    New_Email nvarchar(500)  NOT NULL,
    Old_Email nvarchar(500)  NOT NULL,
    New_Phone nvarchar(20)  NOT NULL,
    Old_Phone nvarchar(500)  NOT NULL,
    CONSTRAINT PeopleDataChangeHistory_ChangedAtIsValid CHECK (ChangedAt <= GetDate()),
    CONSTRAINT PeopleDataChangeHistory_NewPostalCodeIsValid CHECK (New_PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR New_PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR New_PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT PeopleDataChangeHistory_New_EmailValid CHECK (New_Email LIKE '%@%'),
    CONSTRAINT PeopleDataChangeHistory_New_BirthDate CHECK (New_BirthDate <= GetDate()),
    CONSTRAINT PeopleDataChangeHistory_New_Phone CHECK (ISNUMERIC(New_Phone)=(1)),
    CONSTRAINT PersonDataChangeHistory_pk PRIMARY KEY  (PersonDataChangeHistoryID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'PeopleDataChangeHistory';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela PeopleDataChangeHistory przechowuje historię zmian danych osobowych w systemie.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'PeopleDataChangeHistory';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','PersonDataChangeHistoryID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'PersonDataChangeHistoryID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator wpisu historii zmian danych osobowych, generowany automatycznie.  ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'PersonDataChangeHistoryID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','PersonID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'PersonID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator osoby, do której odnosi się historia zmian.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'PersonID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','ChangedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'ChangedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data i czas dokonania zmiany.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'ChangedAt';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_FirstName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_FirstName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowe imię.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_FirstName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_FirstName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_FirstName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stare imię.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_FirstName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_LastName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_LastName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowe nazwisko.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_LastName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_LastName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_LastName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stare nazwisko.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_LastName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_BirthDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_BirthDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowa data urodzenia.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_BirthDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_BirthDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_BirthDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stara data urodzenia.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_BirthDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_Address'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_Address';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowy adres zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_Address';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_Address'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_Address';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stary adres zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_Address';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_City'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_City';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowe miasto zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_City';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_City'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_City';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stare miasto zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_City';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_Region'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_Region';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowy region zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_Region';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_Region'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_Region';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stary region zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_Region';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_PostalCode'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_PostalCode';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowy kod pocztowy zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_PostalCode';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_PostalCode'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_PostalCode';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stary kod pocztowy zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_PostalCode';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_Country'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_Country';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowy kraj zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_Country';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_Country'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_Country';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stary kraj zamieszkania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_Country';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_Email'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_Email';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowy adres e-mail.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_Email';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_Email'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_Email';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stary adres e-mail.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_Email';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','New_Phone'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_Phone';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowy numer telefonu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_Phone';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PeopleDataChangeHistory', 'COLUMN','Old_Phone'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PeopleDataChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_Phone';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stary numer telefonu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PeopleDataChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_Phone';

-- Table: ProductPriceChangeHistory
CREATE TABLE ProductPriceChangeHistory (
    ProductPriceChangeHistoryID int  NOT NULL IDENTITY,
    ProductID int  NOT NULL,
    Old_Price money  NOT NULL,
    New_Price money  NULL,
    Old_AdvancePayment money  NULL,
    New_AdvancePayment money  NULL,
    ChangedAt datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT ProductHistory_ChangedAtIsValid CHECK (ChangedAt <= GetDate()),
    CONSTRAINT ProductHIstory_NewPriceIsValid CHECK (New_price >= 0),
    CONSTRAINT ProductHistory_NewAdvancePaymentIsValid CHECK (New_AdvancePayment > 0),
    CONSTRAINT ProductPriceChangeHistory_pk PRIMARY KEY  (ProductPriceChangeHistoryID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ProductPriceChangeHistory', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'ProductPriceChangeHistory';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela ProductPriceChangeHistory przechowuje historię zmian cen produktów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'ProductPriceChangeHistory';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ProductPriceChangeHistory', 'COLUMN','ProductPriceChangeHistoryID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ProductPriceChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'ProductPriceChangeHistoryID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator historii zmian cen produktów.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ProductPriceChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'ProductPriceChangeHistoryID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ProductPriceChangeHistory', 'COLUMN','ProductID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ProductPriceChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'ProductID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator produktu, którego cena uległa zmianie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ProductPriceChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'ProductID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ProductPriceChangeHistory', 'COLUMN','Old_Price'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ProductPriceChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_Price';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stara cena produktu przed zmianą.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ProductPriceChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_Price';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ProductPriceChangeHistory', 'COLUMN','New_Price'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ProductPriceChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_Price';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowa cena produktu po zmianie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ProductPriceChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_Price';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ProductPriceChangeHistory', 'COLUMN','Old_AdvancePayment'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ProductPriceChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'Old_AdvancePayment';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Stara wartość zaliczki przed zmianą.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ProductPriceChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'Old_AdvancePayment';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ProductPriceChangeHistory', 'COLUMN','New_AdvancePayment'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ProductPriceChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'New_AdvancePayment';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowa wartość zaliczki po zmianie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ProductPriceChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'New_AdvancePayment';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'ProductPriceChangeHistory', 'COLUMN','ChangedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'ProductPriceChangeHistory',
          @level2type = N'COLUMN',
          @level2name = 'ChangedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data dokonania zmiany.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'ProductPriceChangeHistory',
     @level2type = N'COLUMN',
     @level2name = 'ChangedAt';

-- Table: Products
CREATE TABLE Products (
    ProductID int  NOT NULL IDENTITY,
    Price money  NOT NULL,
    AdvancePayment money  NULL,
    ProductType nvarchar(max)  NOT NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    ClosedAt datetime  NULL,
    CONSTRAINT Products_PriceIsValid CHECK (Price >= 0),
    CONSTRAINT Products_AdvancePaymentIsValid CHECK ((AdvancePayment > 0 AND AdvancePayment < Price) OR (AdvancePayment IS NULL)),
    CONSTRAINT Products_ProductTypeIsValid CHECK (ProductType IN ('studies', 'course','webinar', 'public study session')),
    CONSTRAINT Products_AddedAtIsValid CHECK (AddedAt <= GetDate()),
    CONSTRAINT Products_ClosedAtIsValid CHECK (ClosedAt <= GetDate() AND ClosedAt >= AddedAt),
    CONSTRAINT Products_pk PRIMARY KEY  (ProductID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Products', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Products';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Products przechowuje informacje o produktach w systemie.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Products';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Products', 'COLUMN','ProductID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Products',
          @level2type = N'COLUMN',
          @level2name = 'ProductID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator produktu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Products',
     @level2type = N'COLUMN',
     @level2name = 'ProductID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Products', 'COLUMN','Price'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Products',
          @level2type = N'COLUMN',
          @level2name = 'Price';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Cena produktu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Products',
     @level2type = N'COLUMN',
     @level2name = 'Price';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Products', 'COLUMN','AdvancePayment'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Products',
          @level2type = N'COLUMN',
          @level2name = 'AdvancePayment';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Wartość zaliczki do zapłaty za produkt.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Products',
     @level2type = N'COLUMN',
     @level2name = 'AdvancePayment';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Products', 'COLUMN','ProductType'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Products',
          @level2type = N'COLUMN',
          @level2name = 'ProductType';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Rodzaj produktu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Products',
     @level2type = N'COLUMN',
     @level2name = 'ProductType';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Products', 'COLUMN','AddedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Products',
          @level2type = N'COLUMN',
          @level2name = 'AddedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data dodania produktu do systemu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Products',
     @level2type = N'COLUMN',
     @level2name = 'AddedAt';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Products', 'COLUMN','ClosedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Products',
          @level2type = N'COLUMN',
          @level2name = 'ClosedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zamknięcia produktu, jeżeli produkt nie jest już dostępny.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Products',
     @level2type = N'COLUMN',
     @level2name = 'ClosedAt';

-- Table: PublicStudySessionParticipants
CREATE TABLE PublicStudySessionParticipants (
    PublicStudySessionParticipantID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    PublicStudySessionID int  NOT NULL,
    SessionPrice money  NOT NULL,
    DuePostponedPayment datetime  NULL,
    FullPricePaymentID int  NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PublicStudySessionParticipants_SessionPriceIsValid CHECK (SessionPrice > 0),
    CONSTRAINT PublicStudySessionParticipants_pk PRIMARY KEY  (PublicStudySessionParticipantID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionParticipants', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'PublicStudySessionParticipants';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela PublicStudySessionParticipants przechowuje informacje o uczestnikach zajęć otwartych.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'PublicStudySessionParticipants';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionParticipants', 'COLUMN','PublicStudySessionParticipantID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionParticipants',
          @level2type = N'COLUMN',
          @level2name = 'PublicStudySessionParticipantID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator uczestnika zajęć otwartych',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionParticipants',
     @level2type = N'COLUMN',
     @level2name = 'PublicStudySessionParticipantID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionParticipants', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionParticipants',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID użytkownika ',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionParticipants',
     @level2type = N'COLUMN',
     @level2name = 'UserID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionParticipants', 'COLUMN','PublicStudySessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionParticipants',
          @level2type = N'COLUMN',
          @level2name = 'PublicStudySessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator zajęć, w których uczestnik bierze udział',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionParticipants',
     @level2type = N'COLUMN',
     @level2name = 'PublicStudySessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionParticipants', 'COLUMN','SessionPrice'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionParticipants',
          @level2type = N'COLUMN',
          @level2name = 'SessionPrice';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Cena uczestnictwa w zajęciach',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionParticipants',
     @level2type = N'COLUMN',
     @level2name = 'SessionPrice';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionParticipants', 'COLUMN','DuePostponedPayment'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionParticipants',
          @level2type = N'COLUMN',
          @level2name = 'DuePostponedPayment';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowa data uiszczenia zapłaty, w przypadku zmiany przez Dyrektora',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionParticipants',
     @level2type = N'COLUMN',
     @level2name = 'DuePostponedPayment';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionParticipants', 'COLUMN','FullPricePaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionParticipants',
          @level2type = N'COLUMN',
          @level2name = 'FullPricePaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator płatności, w przypadku jej uiszczenia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionParticipants',
     @level2type = N'COLUMN',
     @level2name = 'FullPricePaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionParticipants', 'COLUMN','AddedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionParticipants',
          @level2type = N'COLUMN',
          @level2name = 'AddedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data dodania uczestnika zajęć otwartych do bazy',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionParticipants',
     @level2type = N'COLUMN',
     @level2name = 'AddedAt';

-- Table: PublicStudySessions
CREATE TABLE PublicStudySessions (
    PublicStudySessionID int  NOT NULL,
    StudiesSessionID int  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CONSTRAINT PublicStudySessions_ak_1 UNIQUE (StudiesSessionID),
    CONSTRAINT PublicStudySessions_pk PRIMARY KEY  (PublicStudySessionID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessions', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'PublicStudySessions';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela PublicStudySessions przechowuje informacje o zajęciach otwartych  (tj. takich, w których użytkownik może uczestniczyć bez zapisywania się na studia).',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'PublicStudySessions';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessions', 'COLUMN','PublicStudySessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessions',
          @level2type = N'COLUMN',
          @level2name = 'PublicStudySessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator zajęć otwartych',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessions',
     @level2type = N'COLUMN',
     @level2name = 'PublicStudySessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessions', 'COLUMN','StudiesSessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessions',
          @level2type = N'COLUMN',
          @level2name = 'StudiesSessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator zajęć',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessions',
     @level2type = N'COLUMN',
     @level2name = 'StudiesSessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessions', 'COLUMN','Description'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessions',
          @level2type = N'COLUMN',
          @level2name = 'Description';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis zajęć otwartych',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessions',
     @level2type = N'COLUMN',
     @level2name = 'Description';

-- Table: PublicStudySessionsAttendanceForOutsiders
CREATE TABLE PublicStudySessionsAttendanceForOutsiders (
    PublicStudySessionID int  NOT NULL,
    PublicStudySessionParticipantID int  NOT NULL,
    Completed bit  NOT NULL,
    CONSTRAINT PublicStudySessionsAttendanceForOutsiders_pk PRIMARY KEY  (PublicStudySessionID,PublicStudySessionParticipantID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionsAttendanceForOutsiders', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'PublicStudySessionsAttendanceForOutsiders';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela PublicStudySessionsAttendanceForOutsiders przechowuje informacje o obecności użytkowników niezapisanych na studia w zajęciach otwartych.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'PublicStudySessionsAttendanceForOutsiders';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionsAttendanceForOutsiders', 'COLUMN','PublicStudySessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionsAttendanceForOutsiders',
          @level2type = N'COLUMN',
          @level2name = 'PublicStudySessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator zajęć otwartych',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionsAttendanceForOutsiders',
     @level2type = N'COLUMN',
     @level2name = 'PublicStudySessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionsAttendanceForOutsiders', 'COLUMN','PublicStudySessionParticipantID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionsAttendanceForOutsiders',
          @level2type = N'COLUMN',
          @level2name = 'PublicStudySessionParticipantID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator uczestnika zajęć otwartych',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionsAttendanceForOutsiders',
     @level2type = N'COLUMN',
     @level2name = 'PublicStudySessionParticipantID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'PublicStudySessionsAttendanceForOutsiders', 'COLUMN','Completed'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'PublicStudySessionsAttendanceForOutsiders',
          @level2type = N'COLUMN',
          @level2name = 'Completed';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Oznaczenie, czy użytkownik wziął udział w zajęciach otwartych.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'PublicStudySessionsAttendanceForOutsiders',
     @level2type = N'COLUMN',
     @level2name = 'Completed';

-- Table: RecordingAccessTime
CREATE TABLE RecordingAccessTime (
    RecordingAcessTimeID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    WebinarID int  NULL,
    CONSTRAINT RecordingAccessTime_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT RecordingAccessTime_NumberOfDaysIsValid CHECK (NumberOfDays >= 0),
    CONSTRAINT RecordingAccessTime_pk PRIMARY KEY  (RecordingAcessTimeID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'RecordingAccessTime', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'RecordingAccessTime';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela RecordingAccessTime przechowuje informacje dotyczące dostępu do nagrania webinaru.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'RecordingAccessTime';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'RecordingAccessTime', 'COLUMN','RecordingAcessTimeID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'RecordingAccessTime',
          @level2type = N'COLUMN',
          @level2name = 'RecordingAcessTimeID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator dostępu do nagrania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'RecordingAccessTime',
     @level2type = N'COLUMN',
     @level2name = 'RecordingAcessTimeID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'RecordingAccessTime', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'RecordingAccessTime',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia okresu dostępu do nagrania.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'RecordingAccessTime',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'RecordingAccessTime', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'RecordingAccessTime',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia okresu dostępu do nagrania (opcjonalna).',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'RecordingAccessTime',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'RecordingAccessTime', 'COLUMN','NumberOfDays'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'RecordingAccessTime',
          @level2type = N'COLUMN',
          @level2name = 'NumberOfDays';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Okres w dniach, przez który dostęp do nagrania jest udostępniony.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'RecordingAccessTime',
     @level2type = N'COLUMN',
     @level2name = 'NumberOfDays';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'RecordingAccessTime', 'COLUMN','WebinarID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'RecordingAccessTime',
          @level2type = N'COLUMN',
          @level2name = 'WebinarID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator webinaru, do którego przypisany jest okres dostępu (opcjonalny).',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'RecordingAccessTime',
     @level2type = N'COLUMN',
     @level2name = 'WebinarID';

-- Table: Roles
CREATE TABLE Roles (
    RoleID int  NOT NULL IDENTITY,
    RoleName nvarchar(200)  NOT NULL,
    CONSTRAINT RoleName UNIQUE (RoleName),
    CONSTRAINT employeeType PRIMARY KEY  (RoleID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Roles', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Roles';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Roles przechowuje informacje o różnych rolach w systemie.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Roles';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Roles', 'COLUMN','RoleID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Roles',
          @level2type = N'COLUMN',
          @level2name = 'RoleID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator roli, generowany automatycznie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Roles',
     @level2type = N'COLUMN',
     @level2name = 'RoleID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Roles', 'COLUMN','RoleName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Roles',
          @level2type = N'COLUMN',
          @level2name = 'RoleName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa roli, opisująca jej funkcję lub uprawnienia w systemie.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Roles',
     @level2type = N'COLUMN',
     @level2name = 'RoleName';

-- Table: StationaryStudiesSessions
CREATE TABLE StationaryStudiesSessions (
    StationaryStudiesSessionID int  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    PostalCode nvarchar(20)  NOT NULL,
    ClassroomNumber nvarchar(30)  NOT NULL,
    CONSTRAINT StationaryStudiesSessions_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT StationaryStudiesSessions_pk PRIMARY KEY  (StationaryStudiesSessionID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StationaryStudiesSessions', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'StationaryStudiesSessions';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela StationaryStudiesSessions przechowuje informacje na temat zajęć stacjonarnych.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'StationaryStudiesSessions';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StationaryStudiesSessions', 'COLUMN','StationaryStudiesSessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StationaryStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'StationaryStudiesSessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator zajęć stacjonarnych',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StationaryStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'StationaryStudiesSessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StationaryStudiesSessions', 'COLUMN','Address'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StationaryStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'Address';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Adres, pod którym odbywają się zajęcia.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StationaryStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'Address';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StationaryStudiesSessions', 'COLUMN','City'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StationaryStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'City';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa miasta, w którym odbywają się zajęcia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StationaryStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'City';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StationaryStudiesSessions', 'COLUMN','Country'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StationaryStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'Country';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa państwa, w którym odbywają się zajęcia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StationaryStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'Country';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StationaryStudiesSessions', 'COLUMN','PostalCode'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StationaryStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'PostalCode';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kod pocztowy do adresu, w którym odbywają się zajęcia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StationaryStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'PostalCode';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StationaryStudiesSessions', 'COLUMN','ClassroomNumber'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StationaryStudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'ClassroomNumber';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nr sali, w której odbywają się zajęcia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StationaryStudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'ClassroomNumber';

-- Table: Students
CREATE TABLE Students (
    StudentID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    StudiesID int  NOT NULL,
    StudiesPrice money  NOT NULL,
    EntryFee money  NOT NULL,
    DuePostponedPayment datetime  NULL,
    EntryFeePaymentID int  NULL,
    RemainingPaymentID int  NULL,
    FullPaymentID int  NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    Completed bit  NOT NULL DEFAULT 0,
    CONSTRAINT Students_PriceIsValid CHECK (StudiesPrice > 0),
    CONSTRAINT Students_EntryFeeIsValid CHECK (EntryFee > 0 AND EntryFee < StudiesPrice),
    CONSTRAINT Students_pk PRIMARY KEY  (StudentID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Students';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Students przechowuje podstawowe informacje o studentach.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Students';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','StudentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'StudentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator studenta',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'StudentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID użytkownika',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'UserID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','StudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'StudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'StudiesID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','StudiesPrice'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'StudiesPrice';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Całkowita cena studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'StudiesPrice';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','EntryFee'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'EntryFee';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Kwota zaliczki',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'EntryFee';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','DuePostponedPayment'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'DuePostponedPayment';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nowa data uiszczenia zapłaty, w przypadku zmiany przez Dyrektora',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'DuePostponedPayment';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','EntryFeePaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'EntryFeePaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator płatności dla zaliczki',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'EntryFeePaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','RemainingPaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'RemainingPaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator spłaty pozostałej kwoty',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'RemainingPaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','FullPaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'FullPaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator spłaty całości studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'FullPaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','AddedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'AddedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data dodania studenta do bazy',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'AddedAt';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Students', 'COLUMN','Completed'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Students',
          @level2type = N'COLUMN',
          @level2name = 'Completed';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Oznaczenie informujące o tym, czy student uzyskał zaliczenie studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Students',
     @level2type = N'COLUMN',
     @level2name = 'Completed';

-- Table: Studies
CREATE TABLE Studies (
    StudiesID int  NOT NULL,
    Name nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CoordinatorID int  NOT NULL,
    StartDate Date  NOT NULL,
    EndDate Date  NOT NULL,
    MaxStudents int  NOT NULL,
    LanguageID int  NOT NULL,
    FieldOfStudiesID int  NOT NULL,
    SemesterNumber int  NOT NULL,
    CONSTRAINT Studies_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Studies_MaxStudentsIsValid CHECK (MaxStudents > 0),
    CONSTRAINT Studies_SemesterIsValid CHECK (SemesterNumber >= 1),
    CONSTRAINT Studies_pk PRIMARY KEY  (StudiesID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Studies';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Studies przechowuje informacje o oferowanych programach studiów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Studies';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','StudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'StudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'StudiesID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','Name'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'Name';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'Name';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','Description'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'Description';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'Description';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','CoordinatorID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'CoordinatorID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator pracownika będącego koordynatorem studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'CoordinatorID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','MaxStudents'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'MaxStudents';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Maksymalna liczba studentów mogących zapisać się na studia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'MaxStudents';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','LanguageID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'LanguageID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID języka, w którym będą prowadzone studia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'LanguageID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','FieldOfStudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'FieldOfStudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID dziedziny studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'FieldOfStudiesID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Studies', 'COLUMN','SemesterNumber'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Studies',
          @level2type = N'COLUMN',
          @level2name = 'SemesterNumber';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Numer semestru studiów',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Studies',
     @level2type = N'COLUMN',
     @level2name = 'SemesterNumber';

-- Table: StudiesSessions
CREATE TABLE StudiesSessions (
    StudiesSessionID int  NOT NULL IDENTITY,
    SubjectID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    LecturerID int  NOT NULL,
    MaxStudents int  NOT NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT StudiesSessions_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MaxStudentsVerification CHECK (MaxStudents > 0),
    CONSTRAINT StudiesSessions_pk PRIMARY KEY  (StudiesSessionID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'StudiesSessions';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela StudiesSessions przechowuje informacje o wszystkich zajęciach w ramach każdego z przedmiotów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'StudiesSessions';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', 'COLUMN','StudiesSessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'StudiesSessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator zajęć',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'StudiesSessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', 'COLUMN','SubjectID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'SubjectID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID przedmiotu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'SubjectID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia zajęć',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia zajęć',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', 'COLUMN','LecturerID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'LecturerID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator pracownika prowadzącego zajęcia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'LecturerID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', 'COLUMN','MaxStudents'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'MaxStudents';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Maksymalna liczba studentów, którzy mogą wziąć udział w zajęciach',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'MaxStudents';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', 'COLUMN','TranslatorID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'TranslatorID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'W przypadku przedmiotu prowadzonego w innym języku - identyfikator tłumacza',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'TranslatorID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessions', 'COLUMN','LanguageID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessions',
          @level2type = N'COLUMN',
          @level2name = 'LanguageID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator języku prowadzenia zajęć',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessions',
     @level2type = N'COLUMN',
     @level2name = 'LanguageID';

-- Table: StudiesSessionsAttendence
CREATE TABLE StudiesSessionsAttendence (
    SessionID int  NOT NULL,
    StudentID int  NOT NULL,
    Completed bit  NOT NULL,
    CONSTRAINT StudiesSessionsAttendence_pk PRIMARY KEY  (SessionID,StudentID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessionsAttendence', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'StudiesSessionsAttendence';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela StudiesSessionsAttendence przechowuje informacje o obecnościach studentów na zajęciach.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'StudiesSessionsAttendence';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessionsAttendence', 'COLUMN','SessionID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessionsAttendence',
          @level2type = N'COLUMN',
          @level2name = 'SessionID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator zajęć',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessionsAttendence',
     @level2type = N'COLUMN',
     @level2name = 'SessionID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessionsAttendence', 'COLUMN','StudentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessionsAttendence',
          @level2type = N'COLUMN',
          @level2name = 'StudentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID studenta zapisaego na zajęcia',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessionsAttendence',
     @level2type = N'COLUMN',
     @level2name = 'StudentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'StudiesSessionsAttendence', 'COLUMN','Completed'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'StudiesSessionsAttendence',
          @level2type = N'COLUMN',
          @level2name = 'Completed';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Oznaczenie obecności studenta na zajęciach,',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'StudiesSessionsAttendence',
     @level2type = N'COLUMN',
     @level2name = 'Completed';

-- Table: SubjectMakeUpPossibilities
CREATE TABLE SubjectMakeUpPossibilities (
    SubjectID int  NOT NULL,
    ProductID int  NOT NULL,
    AttendanceValue int  NOT NULL,
    CONSTRAINT SubjectMakeUpPossibilities_AttendanceValue CHECK (AttendanceValue > 0),
    CONSTRAINT SubjectMakeUpPossibilities_pk PRIMARY KEY  (SubjectID,ProductID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'SubjectMakeUpPossibilities', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'SubjectMakeUpPossibilities';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela SubjectMakeUpPossibilities przechowuje informacje na temat wszystkich możliwych "zastępstw", które student może zrealizować w przypadku niezaliczenia przez niego danego przedmiotu.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'SubjectMakeUpPossibilities';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'SubjectMakeUpPossibilities', 'COLUMN','SubjectID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'SubjectMakeUpPossibilities',
          @level2type = N'COLUMN',
          @level2name = 'SubjectID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator przedmiotu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'SubjectMakeUpPossibilities',
     @level2type = N'COLUMN',
     @level2name = 'SubjectID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'SubjectMakeUpPossibilities', 'COLUMN','ProductID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'SubjectMakeUpPossibilities',
          @level2type = N'COLUMN',
          @level2name = 'ProductID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator produktu, którego zakup oraz zrealizowanie zwalniają z zaliczenia przedmiotu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'SubjectMakeUpPossibilities',
     @level2type = N'COLUMN',
     @level2name = 'ProductID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'SubjectMakeUpPossibilities', 'COLUMN','AttendanceValue'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'SubjectMakeUpPossibilities',
          @level2type = N'COLUMN',
          @level2name = 'AttendanceValue';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Wartość obecności',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'SubjectMakeUpPossibilities',
     @level2type = N'COLUMN',
     @level2name = 'AttendanceValue';

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID int  NOT NULL IDENTITY,
    StudiesID int  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CoordinatorID int  NOT NULL,
    SubjectName nvarchar(max)  NOT NULL,
    CONSTRAINT SubjectID PRIMARY KEY  (SubjectID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Subjects', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Subjects';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Subjects przechowuje informacje na temat wszystkich przedmiotów podpiętych pod wszystkie kierunki studiów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Subjects';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Subjects', 'COLUMN','SubjectID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Subjects',
          @level2type = N'COLUMN',
          @level2name = 'SubjectID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator przedmiotu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Subjects',
     @level2type = N'COLUMN',
     @level2name = 'SubjectID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Subjects', 'COLUMN','StudiesID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Subjects',
          @level2type = N'COLUMN',
          @level2name = 'StudiesID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'ID studiów, pod które podpięty jest przedmiot',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Subjects',
     @level2type = N'COLUMN',
     @level2name = 'StudiesID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Subjects', 'COLUMN','Description'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Subjects',
          @level2type = N'COLUMN',
          @level2name = 'Description';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis przedmiotu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Subjects',
     @level2type = N'COLUMN',
     @level2name = 'Description';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Subjects', 'COLUMN','CoordinatorID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Subjects',
          @level2type = N'COLUMN',
          @level2name = 'CoordinatorID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator pracownika będącego koordynatorem przedmiotu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Subjects',
     @level2type = N'COLUMN',
     @level2name = 'CoordinatorID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Subjects', 'COLUMN','SubjectName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Subjects',
          @level2type = N'COLUMN',
          @level2name = 'SubjectName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa przedmiotu',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Subjects',
     @level2type = N'COLUMN',
     @level2name = 'SubjectName';

-- Table: Users
CREATE TABLE Users (
    UserID int  NOT NULL,
    CONSTRAINT Users_pk PRIMARY KEY  (UserID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Users', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Users';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Users przechowuje podstawowe informacje o użytkownikach.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Users';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Users', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Users',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator użytkownika, stanowiący klucz główny tabeli.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Users',
     @level2type = N'COLUMN',
     @level2name = 'UserID';

-- Table: WebinarParticipants
CREATE TABLE WebinarParticipants (
    WebinarParticipantID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    WebinarID int  NOT NULL,
    WebinarPrice money  NOT NULL,
    DuePostponedPayment datetime  NULL,
    FullPricePaymentID int  NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT WebinarParticipants_WebinarPrice CHECK (WebinarPrice >= 0),
    CONSTRAINT WebinarParticipants_FulPricePaymentID CHECK (FullPricePaymentID IS NOT NULL OR  (DuePostponedPayment IS NOT NULL OR      WebinarPrice = 0)),
    CONSTRAINT WebinarParticipants_pk PRIMARY KEY  (WebinarParticipantID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarParticipants', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'WebinarParticipants';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela WebinarParticipants przechowuje informacje o uczestnikach webinarów.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'WebinarParticipants';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarParticipants', 'COLUMN','WebinarParticipantID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarParticipants',
          @level2type = N'COLUMN',
          @level2name = 'WebinarParticipantID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator uczestnika webinaru.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarParticipants',
     @level2type = N'COLUMN',
     @level2name = 'WebinarParticipantID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarParticipants', 'COLUMN','UserID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarParticipants',
          @level2type = N'COLUMN',
          @level2name = 'UserID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator użytkownika, który jest uczestnikiem webinaru.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarParticipants',
     @level2type = N'COLUMN',
     @level2name = 'UserID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarParticipants', 'COLUMN','WebinarID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarParticipants',
          @level2type = N'COLUMN',
          @level2name = 'WebinarID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator webinaru, do którego przypisany jest uczestnik.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarParticipants',
     @level2type = N'COLUMN',
     @level2name = 'WebinarID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarParticipants', 'COLUMN','WebinarPrice'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarParticipants',
          @level2type = N'COLUMN',
          @level2name = 'WebinarPrice';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Cena uczestnictwa w webinarze.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarParticipants',
     @level2type = N'COLUMN',
     @level2name = 'WebinarPrice';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarParticipants', 'COLUMN','DuePostponedPayment'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarParticipants',
          @level2type = N'COLUMN',
          @level2name = 'DuePostponedPayment';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data odroczonego terminu płatności.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarParticipants',
     @level2type = N'COLUMN',
     @level2name = 'DuePostponedPayment';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarParticipants', 'COLUMN','FullPricePaymentID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarParticipants',
          @level2type = N'COLUMN',
          @level2name = 'FullPricePaymentID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator pełnej płatności.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarParticipants',
     @level2type = N'COLUMN',
     @level2name = 'FullPricePaymentID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarParticipants', 'COLUMN','AddedAt'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarParticipants',
          @level2type = N'COLUMN',
          @level2name = 'AddedAt';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data dodania uczestnika do webinaru.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarParticipants',
     @level2type = N'COLUMN',
     @level2name = 'AddedAt';

-- Table: Webinars
CREATE TABLE Webinars (
    WebinarID int  NOT NULL,
    WebinarName nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    RecordingLink nvarchar(max)  NULL,
    WebinarLink nvarchar(max)  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    RecordingReleaseDate date  NULL,
    CONSTRAINT Webinars_RecodingReleaseDateValid CHECK (RecordingReleaseDate >= EndDate),
    CONSTRAINT Webinars_RecodingLinkRelationWithRecordingReleaseDate CHECK ((RecordingReleaseDate IS NULL AND RecordingLink IS NULL) OR (RecordingReleaseDate IS NOT NULL AND RecordingLink IS NOT NULL)),
    CONSTRAINT Webinars_DateRangeIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Webinars_pk PRIMARY KEY  (WebinarID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'Webinars';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela Webinars przechowuje informacje dotyczące webinarów oferowanych w systemie.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'Webinars';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','WebinarID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'WebinarID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unikalny identyfikator webinaru.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'WebinarID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','WebinarName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'WebinarName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Nazwa webinaru.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'WebinarName';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','Description'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'Description';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Opis webinaru, zawierający informacje na temat treści i celów.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'Description';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','StartDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'StartDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data rozpoczęcia webinaru.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'StartDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','EndDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'EndDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data zakończenia webinaru.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'EndDate';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','RecordingLink'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'RecordingLink';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Link do nagrania webinaru (opcjonalny).',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'RecordingLink';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','WebinarLink'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'WebinarLink';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Link do udziału w webinarze.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'WebinarLink';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','LecturerID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'LecturerID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator prowadzącego webinar, który jest pracownikiem systemu.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'LecturerID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','TranslatorID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'TranslatorID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator tłumacza webinaru (opcjonalny).',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'TranslatorID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','LanguageID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'LanguageID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator języka, w jakim prowadzony jest webinar.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'LanguageID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'Webinars', 'COLUMN','RecordingReleaseDate'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'Webinars',
          @level2type = N'COLUMN',
          @level2name = 'RecordingReleaseDate';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Data udostępnienia nagrania webinaru (opcjonalna).',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'Webinars',
     @level2type = N'COLUMN',
     @level2name = 'RecordingReleaseDate';

-- Table: WebinarsAttendence
CREATE TABLE WebinarsAttendence (
    WebinarID int  NOT NULL,
    WebinarParticipantID int  NOT NULL,
    WasPresent bit  NOT NULL,
    CONSTRAINT WebinarsAttendence_pk PRIMARY KEY  (WebinarID,WebinarParticipantID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarsAttendence', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
      @level0name = 'dbo',
      @level1type = N'TABLE',
        @level1name = 'WebinarsAttendence';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Tabela WebinarsAttendance przechowuje informacje dotyczące uczestnictwa w webinarze.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'WebinarsAttendence';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarsAttendence', 'COLUMN','WebinarID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarsAttendence',
          @level2type = N'COLUMN',
          @level2name = 'WebinarID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator webinaru, do którego odnosi się uczestnictwo.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarsAttendence',
     @level2type = N'COLUMN',
     @level2name = 'WebinarID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarsAttendence', 'COLUMN','WebinarParticipantID'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarsAttendence',
          @level2type = N'COLUMN',
          @level2name = 'WebinarParticipantID';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Identyfikator uczestnika webinaru.',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarsAttendence',
     @level2type = N'COLUMN',
     @level2name = 'WebinarParticipantID';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'WebinarsAttendence', 'COLUMN','WasPresent'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'WebinarsAttendence',
          @level2type = N'COLUMN',
          @level2name = 'WasPresent';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Wartość logiczna określająca, czy uczestnik był obecny na webinarze (1 - obecny, 0 - nieobecny).',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'WebinarsAttendence',
     @level2type = N'COLUMN',
     @level2name = 'WasPresent';

-- foreign keys
-- Reference: AttendanceForOutsiders (table: PublicStudySessionsAttendanceForOutsiders)
ALTER TABLE PublicStudySessionsAttendanceForOutsiders ADD CONSTRAINT AttendanceForOutsiders
    FOREIGN KEY (PublicStudySessionParticipantID)
    REFERENCES PublicStudySessionParticipants (PublicStudySessionParticipantID);

-- Reference: CartHistory_Products (table: CartHistory)
ALTER TABLE CartHistory ADD CONSTRAINT CartHistory_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: CartHistory_Users (table: CartHistory)
ALTER TABLE CartHistory ADD CONSTRAINT CartHistory_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Carts_Products (table: Carts)
ALTER TABLE Carts ADD CONSTRAINT Carts_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: Carts_Users (table: Carts)
ALTER TABLE Carts ADD CONSTRAINT Carts_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: CourseOfflineSessions_CoursesSessions (table: CourseOfflineSessions)
ALTER TABLE CourseOfflineSessions ADD CONSTRAINT CourseOfflineSessions_CoursesSessions
    FOREIGN KEY (CourseOfflineSessionID)
    REFERENCES CoursesSessions (CourseSessionID)
    ON DELETE  CASCADE;

-- Reference: CourseOnlineSessions_CoursesSessions (table: CourseOnlineSessions)
ALTER TABLE CourseOnlineSessions ADD CONSTRAINT CourseOnlineSessions_CoursesSessions
    FOREIGN KEY (CourseOnlineSessionID)
    REFERENCES CoursesSessions (CourseSessionID)
    ON DELETE  CASCADE;

-- Reference: CourseParticipants_Courses (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: CourseParticipants_EntryFeePayments (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_EntryFeePayments
    FOREIGN KEY (EntryFeePaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: CourseParticipants_FullPricePayments (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_FullPricePayments
    FOREIGN KEY (FullPricePaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: CourseParticipants_RemainingPayments (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_RemainingPayments
    FOREIGN KEY (RemainingPaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: CourseParticipants_Users (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: CourseSessionsAttendance_CourseParticipants (table: CourseSessionsAttendance)
ALTER TABLE CourseSessionsAttendance ADD CONSTRAINT CourseSessionsAttendance_CourseParticipants
    FOREIGN KEY (CourseParticipantID)
    REFERENCES CourseParticipants (CourseParticipantID)
    ON DELETE  CASCADE;

-- Reference: CourseSessionsAttendance_CoursesSessions (table: CourseSessionsAttendance)
ALTER TABLE CourseSessionsAttendance ADD CONSTRAINT CourseSessionsAttendance_CoursesSessions
    FOREIGN KEY (CourseSessionID)
    REFERENCES CoursesSessions (CourseSessionID)
    ON DELETE  CASCADE;

-- Reference: CourseStationarySessions_CoursesSessions (table: CourseStationarySessions)
ALTER TABLE CourseStationarySessions ADD CONSTRAINT CourseStationarySessions_CoursesSessions
    FOREIGN KEY (CourseStationarySessionID)
    REFERENCES CoursesSessions (CourseSessionID)
    ON DELETE  CASCADE;

-- Reference: CoursesSessions_Employees (table: CoursesSessions)
ALTER TABLE CoursesSessions ADD CONSTRAINT CoursesSessions_Employees
    FOREIGN KEY (LecturerID)
    REFERENCES Employees (EmployeeID);

-- Reference: CoursesSessions_Languages (table: CoursesSessions)
ALTER TABLE CoursesSessions ADD CONSTRAINT CoursesSessions_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: CoursesSessions_Modules (table: CoursesSessions)
ALTER TABLE CoursesSessions ADD CONSTRAINT CoursesSessions_Modules
    FOREIGN KEY (ModuleID)
    REFERENCES Modules (ModuleID)
    ON DELETE  CASCADE;

-- Reference: CoursesSessions_Translators (table: CoursesSessions)
ALTER TABLE CoursesSessions ADD CONSTRAINT CoursesSessions_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Courses_Employees (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Employees
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Courses_Languages (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Courses_Products (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Products
    FOREIGN KEY (CourseID)
    REFERENCES Products (ProductID);

-- Reference: DaysOfPracticeLaws_Internships (table: DaysInInternship)
ALTER TABLE DaysInInternship ADD CONSTRAINT DaysOfPracticeLaws_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);

-- Reference: DiplomasSent_Products (table: DiplomasSent)
ALTER TABLE DiplomasSent ADD CONSTRAINT DiplomasSent_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: DiplomasSent_Users (table: DiplomasSent)
ALTER TABLE DiplomasSent ADD CONSTRAINT DiplomasSent_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: EmployeeCategories_Employees (table: EmployeeRoles)
ALTER TABLE EmployeeRoles ADD CONSTRAINT EmployeeCategories_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees (EmployeeID)
    ON DELETE  CASCADE;

-- Reference: EmployeeRoles_Roles (table: EmployeeRoles)
ALTER TABLE EmployeeRoles ADD CONSTRAINT EmployeeRoles_Roles
    FOREIGN KEY (RoleID)
    REFERENCES Roles (RoleID)
    ON DELETE  CASCADE;

-- Reference: Employees_People (table: Employees)
ALTER TABLE Employees ADD CONSTRAINT Employees_People
    FOREIGN KEY (EmployeeID)
    REFERENCES People (PersonID);

-- Reference: ExamsGrades_Exams (table: ExamsGrades)
ALTER TABLE ExamsGrades ADD CONSTRAINT ExamsGrades_Exams
    FOREIGN KEY (ExamID)
    REFERENCES Exams (ExamID);

-- Reference: Exams_Subjects (table: Exams)
ALTER TABLE Exams ADD CONSTRAINT Exams_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Grades_Students (table: ExamsGrades)
ALTER TABLE ExamsGrades ADD CONSTRAINT Grades_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: InternshipAttendence_Internships (table: InternshipDetails)
ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipAttendence_Internships
    FOREIGN KEY (IntershipID)
    REFERENCES Internships (InternshipID);

-- Reference: InternshipDetails_Students (table: InternshipDetails)
ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: Internships_Studies (table: Internships)
ALTER TABLE Internships ADD CONSTRAINT Internships_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: MadeUpAttendance_Students (table: MadeUpAttendance)
ALTER TABLE MadeUpAttendance ADD CONSTRAINT MadeUpAttendance_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: MadeUpAttendance_SubjectMakeUpPossibilities (table: MadeUpAttendance)
ALTER TABLE MadeUpAttendance ADD CONSTRAINT MadeUpAttendance_SubjectMakeUpPossibilities
    FOREIGN KEY (SubjectID,ProductID)
    REFERENCES SubjectMakeUpPossibilities (SubjectID,ProductID);

-- Reference: MaxDaysForPaymentBeforeCourseStart_Courses (table: MaxDaysForPaymentBeforeCourseStart)
ALTER TABLE MaxDaysForPaymentBeforeCourseStart ADD CONSTRAINT MaxDaysForPaymentBeforeCourseStart_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: MaxDaysForPaymentBeforeStudiesStart_Studies (table: MaxDaysForPaymentBeforeStudiesStart)
ALTER TABLE MaxDaysForPaymentBeforeStudiesStart ADD CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: MinAttendancePercentageToPassCourse_Courses (table: MinAttendancePercentageToPassCourse)
ALTER TABLE MinAttendancePercentageToPassCourse ADD CONSTRAINT MinAttendancePercentageToPassCourse_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: MinAttendancePercentageToPassInternship_Internships (table: MinAttendancePercentageToPassInternship)
ALTER TABLE MinAttendancePercentageToPassInternship ADD CONSTRAINT MinAttendancePercentageToPassInternship_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);

-- Reference: MinAttendancePercentageToPassStudies_Studies (table: MinAttendancePercentageToPassStudies)
ALTER TABLE MinAttendancePercentageToPassStudies ADD CONSTRAINT MinAttendancePercentageToPassStudies_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Modules_Courses (table: Modules)
ALTER TABLE Modules ADD CONSTRAINT Modules_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: OnlineStudiesSessions_StudySessions (table: OnlineStudiesSessions)
ALTER TABLE OnlineStudiesSessions ADD CONSTRAINT OnlineStudiesSessions_StudySessions
    FOREIGN KEY (OnlineStudiesSessionID)
    REFERENCES StudiesSessions (StudiesSessionID)
    ON DELETE  CASCADE;

-- Reference: OrderHistory_Products (table: Payments)
ALTER TABLE Payments ADD CONSTRAINT OrderHistory_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: OrderHistory_Users (table: Payments)
ALTER TABLE Payments ADD CONSTRAINT OrderHistory_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: PeopleDataChangeHistory_People (table: PeopleDataChangeHistory)
ALTER TABLE PeopleDataChangeHistory ADD CONSTRAINT PeopleDataChangeHistory_People
    FOREIGN KEY (PersonID)
    REFERENCES People (PersonID);

-- Reference: ProductHistory_Products (table: ProductPriceChangeHistory)
ALTER TABLE ProductPriceChangeHistory ADD CONSTRAINT ProductHistory_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID)
    ON DELETE  CASCADE;

-- Reference: PublicStudySessionParticipants_Payments (table: PublicStudySessionParticipants)
ALTER TABLE PublicStudySessionParticipants ADD CONSTRAINT PublicStudySessionParticipants_Payments
    FOREIGN KEY (FullPricePaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: PublicStudySessionParticipants_PublicStudySessions (table: PublicStudySessionParticipants)
ALTER TABLE PublicStudySessionParticipants ADD CONSTRAINT PublicStudySessionParticipants_PublicStudySessions
    FOREIGN KEY (PublicStudySessionID)
    REFERENCES PublicStudySessions (PublicStudySessionID);

-- Reference: PublicStudySessionsAttendanceForOutsiders_PublicStudySessions (table: PublicStudySessionsAttendanceForOutsiders)
ALTER TABLE PublicStudySessionsAttendanceForOutsiders ADD CONSTRAINT PublicStudySessionsAttendanceForOutsiders_PublicStudySessions
    FOREIGN KEY (PublicStudySessionID)
    REFERENCES PublicStudySessions (PublicStudySessionID);

-- Reference: PublicStudySessions_Products (table: PublicStudySessions)
ALTER TABLE PublicStudySessions ADD CONSTRAINT PublicStudySessions_Products
    FOREIGN KEY (PublicStudySessionID)
    REFERENCES Products (ProductID);

-- Reference: PublicStudySessions_StudiesSessions (table: PublicStudySessions)
ALTER TABLE PublicStudySessions ADD CONSTRAINT PublicStudySessions_StudiesSessions
    FOREIGN KEY (StudiesSessionID)
    REFERENCES StudiesSessions (StudiesSessionID)
    ON DELETE  CASCADE;

-- Reference: RecordingAccessTime_Webinars (table: RecordingAccessTime)
ALTER TABLE RecordingAccessTime ADD CONSTRAINT RecordingAccessTime_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID)
    ON DELETE  CASCADE;

-- Reference: StationaryStudiesSessions_StudySessions (table: StationaryStudiesSessions)
ALTER TABLE StationaryStudiesSessions ADD CONSTRAINT StationaryStudiesSessions_StudySessions
    FOREIGN KEY (StationaryStudiesSessionID)
    REFERENCES StudiesSessions (StudiesSessionID)
    ON DELETE  CASCADE;

-- Reference: Students_FullPayments (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_FullPayments
    FOREIGN KEY (RemainingPaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: Students_Payments (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Payments
    FOREIGN KEY (FullPaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: Students_RemainingPayments (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_RemainingPayments
    FOREIGN KEY (EntryFeePaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: Students_Studies (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Students_Users (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: StudiesSessionsAttendence_Students (table: StudiesSessionsAttendence)
ALTER TABLE StudiesSessionsAttendence ADD CONSTRAINT StudiesSessionsAttendence_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: StudiesSessions_Employees (table: StudiesSessions)
ALTER TABLE StudiesSessions ADD CONSTRAINT StudiesSessions_Employees
    FOREIGN KEY (TranslatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: StudiesSessions_Languages (table: StudiesSessions)
ALTER TABLE StudiesSessions ADD CONSTRAINT StudiesSessions_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Studies_Employees (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Employees
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Studies_FieldsOfStudies (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_FieldsOfStudies
    FOREIGN KEY (FieldOfStudiesID)
    REFERENCES FieldsOfStudies (FieldOfStudiesID);

-- Reference: Studies_Languages (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Studies_Products (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Products
    FOREIGN KEY (StudiesID)
    REFERENCES Products (ProductID);

-- Reference: Studies_Subjects (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Studies_Subjects
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: StudySessionsAttendence_StudySessions (table: StudiesSessionsAttendence)
ALTER TABLE StudiesSessionsAttendence ADD CONSTRAINT StudySessionsAttendence_StudySessions
    FOREIGN KEY (SessionID)
    REFERENCES StudiesSessions (StudiesSessionID)
    ON DELETE  CASCADE;

-- Reference: StudySessions_Employees (table: StudiesSessions)
ALTER TABLE StudiesSessions ADD CONSTRAINT StudySessions_Employees
    FOREIGN KEY (LecturerID)
    REFERENCES Employees (EmployeeID);

-- Reference: StudySessions_Subjects (table: StudiesSessions)
ALTER TABLE StudiesSessions ADD CONSTRAINT StudySessions_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: SubjectMakeUpPossibilities_Products (table: SubjectMakeUpPossibilities)
ALTER TABLE SubjectMakeUpPossibilities ADD CONSTRAINT SubjectMakeUpPossibilities_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: SubjectMakeUpPossibilities_Subjects (table: SubjectMakeUpPossibilities)
ALTER TABLE SubjectMakeUpPossibilities ADD CONSTRAINT SubjectMakeUpPossibilities_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Subjects_Employees (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Subjects_Employees
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Users_People (table: Users)
ALTER TABLE Users ADD CONSTRAINT Users_People
    FOREIGN KEY (UserID)
    REFERENCES People (PersonID);

-- Reference: WebinarParticipants_Payments (table: WebinarParticipants)
ALTER TABLE WebinarParticipants ADD CONSTRAINT WebinarParticipants_Payments
    FOREIGN KEY (FullPricePaymentID)
    REFERENCES Payments (PaymentID)
    ON DELETE  CASCADE;

-- Reference: WebinarParticipants_Users (table: WebinarParticipants)
ALTER TABLE WebinarParticipants ADD CONSTRAINT WebinarParticipants_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID)
    ON DELETE  CASCADE;

-- Reference: WebinarParticipants_Webinars (table: WebinarParticipants)
ALTER TABLE WebinarParticipants ADD CONSTRAINT WebinarParticipants_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID)
    ON DELETE  CASCADE;

-- Reference: WebinarsAttendence_WebinarParticipants (table: WebinarsAttendence)
ALTER TABLE WebinarsAttendence ADD CONSTRAINT WebinarsAttendence_WebinarParticipants
    FOREIGN KEY (WebinarParticipantID)
    REFERENCES WebinarParticipants (WebinarParticipantID);

-- Reference: WebinarsAttendence_Webinars (table: WebinarsAttendence)
ALTER TABLE WebinarsAttendence ADD CONSTRAINT WebinarsAttendence_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID)
    ON DELETE  CASCADE;

-- Reference: Webinars_Languages (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Webinars_Lecturers (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Lecturers
    FOREIGN KEY (TranslatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Webinars_Products (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Products
    FOREIGN KEY (WebinarID)
    REFERENCES Products (ProductID);

-- Reference: Webinars_Translators (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Translators
    FOREIGN KEY (LecturerID)
    REFERENCES Employees (EmployeeID);

-- End of file.

