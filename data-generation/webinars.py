import datetime
import random

random.seed(42)

global_participant_id = 0


def get_new_participant_id():
    global global_participant_id
    global_participant_id += 1
    return global_participant_id


global_payment_id = 10_000


def get_new_payment_id():
    global global_payment_id
    global_payment_id += 1
    return global_payment_id


def get_n_user_ids(n):
    user_ids = list(range(50, 250))
    random.shuffle(user_ids)
    return user_ids[:n]


def generate_webinars():
    """
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
      CONSTRAINT Webinars_RecodingReleaseDateValid CHECK (RecordingReleaseDate >= ReleaseDate),
      CONSTRAINT Webinars_RecodingLinkRelationWithRecordingReleaseDate CHECK ((RecordingReleaseDate IS NULL AND RecordingLink IS NULL) OR (RecordingReleaseDate IS NOT NULL AND RecordingLink IS NOT NULL)),
      CONSTRAINT Webinars_pk PRIMARY KEY  (WebinarID)
  );


  -- Table: WebinarParticipants
  CREATE TABLE WebinarParticipants (
      WebinarParticipantID int  NOT NULL,
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
    -- Table: WebinarsAttendence
    CREATE TABLE WebinarsAttendence (
    WebinarID int  NOT NULL,
        WebinarParticipantID int  NOT NULL,
    CONSTRAINT WebinarsAttendence_pk PRIMARY KEY  (WebinarID,WebinarParticipantID)
    );
    -- Table: Products
    CREATE TABLE Products (
        ProductID int  NOT NULL,
        Price money  NOT NULL,
        AdvancePayment money  NULL,
        ProductType nvarchar(max)  NOT NULL,
        AddedAt datetime  NOT NULL,
        ClosedAt datetime  NOT NULL,
        CONSTRAINT Products_PriceIsValid CHECK (Price >= 0),
        CONSTRAINT Products_AdvancePaymentIsValid CHECK ((AdvancePayment > 0 AND AdvancePayment < Price) OR (AdvancePayment IS NULL)),
        CONSTRAINT Products_ProductTypeIsValid CHECK (ProductType IN ('studies', 'course','webinar', 'public study session')),
        CONSTRAINT Products_AddedAtIsValid CHECK (AddedAt <= GetDate()),
        CONSTRAINT Products_ClosedAtIsValid CHECK (ClosedAt <= GetDate() AND ClosedAt >= AddedAt),
        CONSTRAINT Products_pk PRIMARY KEY  (ProductID)
    );
    CREATE TABLE Payments (
        PaymentID int  NOT NULL,
        UserID int  NOT NULL,
        ProductID int  NOT NULL,
        Price money  NOT NULL,
        Date date  NOT NULL,
        Status nvarchar(300)  NOT NULL,
        CONSTRAINT Payments_Price CHECK (Price >= 0),
        CONSTRAINT Payments_Status CHECK (Status in ('Successful', 'Failed')),
        CONSTRAINT Payments_Date CHECK (Date <= GetDate()),
        CONSTRAINT Payments_pk PRIMARY KEY  (PaymentID)
    );
  """
    names = [
        "Nowoczesne Trendy w Marketingu Internetowym",
        "Zarządzanie Wielokulturowym Zespołem",
        "Skuteczne Negocjacje Biznesowe",
        "E-commerce: Strategie Sukcesu",
        "Rola Sztucznej Inteligencji w Biznesie",
        "Sztuka Rozwiązywania Konfliktów w Pracy",
        "Praktyki Lidera: Inspiracja i Motywacja Zespołu",
        "Kreatywność w Pracy: Jak Ją Rozwijać?",
        "Sekrety Efektywnego Networkingu Zawodowego",
        "Analiza Ryzyka Projektu: Kluczowe Aspekty",
        "Zarządzanie Zmianą Organizacyjną",
        "Etyka w Technologii: Wyzwania i Odpowiedzialność",
        "Strategie Efektywnego Kierowania Projektem",
        "Zrównoważony Rozwój: Wprowadzanie Do Praktyki",
        "Umiejętności Prezentacyjne: Jak Zachwycić Publiczność",
        "Budowanie Zespołu: Klucz do Sukcesu Organizacji",
        "Przyszłość Pracy Zdalnej: Wyzwania i Korzyści",
        "Biznes a Zrównoważona Konsumpcja",
        "Edukacja Finansowa: Jak Zarządzać Swoimi Finansami",
        "Rozwój Osobisty: Klucz do Kariery Zawodowej"
    ]

    descriptions = [
        "Dowiedz się, jakie są najnowsze trendy w dziedzinie marketingu internetowego i jak je wykorzystać.",
        "Omówimy wyzwania i korzyści zarządzania zespołem o różnych kulturach i pochodzeniach.",
        "Odkryj tajniki skutecznych negocjacji biznesowych i osiągaj korzystne porozumienia.",
        "Zanurz się w strategiach sukcesu e-commerce i zwiększ swoją obecność online.",
        "Przeanalizujemy rolę sztucznej inteligencji w biznesie i jakie ma potencjalne zastosowania.",
        "Dowiedz się, jak skutecznie rozwiązywać konflikty w miejscu pracy i utrzymywać harmonię.",
        "Przyjrzymy się praktykom liderów i jak inspirują oraz motywują swoje zespoły do działania.",
        "Rozwijaj swoją kreatywność w pracy i zdobywaj umiejętności generowania nowych pomysłów.",
        "Odkryj sekrety skutecznego budowania relacji zawodowych i rozwoju networkingu.",
        "Przeanalizujemy kluczowe aspekty analizy ryzyka projektu i jak minimalizować potencjalne zagrożenia.",
        "Zarządzaj zmianami organizacyjnymi i skutecznie wprowadzaj nowe inicjatywy w firmie.",
        "Omówimy etyczne wyzwania związane z technologią i odpowiedzialność biznesu.",
        "Przedstawimy strategie efektywnego kierowania projektami i osiągania celów projektowych.",
        "Zapoznaj się z praktycznymi krokami wprowadzania zrównoważonego rozwoju w codziennej działalności.",
        "Doskonal swoje umiejętności prezentacyjne i naucz się zachwycać swoją publiczność.",
        "Zbuduj silny zespół i zrozum, dlaczego jest to klucz do sukcesu każdej organizacji.",
        "Przeanalizujemy wyzwania i korzyści związane z pracą zdalną i jak efektywnie zarządzać zespołem na odległość.",
        "Omówimy, jak firmy mogą integrować zrównoważoną konsumpcję w swojej strategii biznesowej.",
        "Dowiedz się, jak zarządzać swoimi finansami i podejmować mądre decyzje finansowe.",
        "Rozwijaj się zawodowo i zdobądź kluczowe umiejętności niezbędne do sukcesu kariery."
    ]

    webinars_table = create_webinars_info(descriptions, names)
    webinars_sql = []
    for w_id in webinars_table:
        winfo = webinars_table[w_id]
        instructions = [generate_product(format_info_for_sql(winfo)),
                        generate_webinar(format_info_for_sql(winfo)),
                        generate_participants(winfo)]
        webinars_sql.append('\n'.join(instructions))
    return '\n'.join(webinars_sql)


def create_webinars_info(descriptions, names):
    webinars_table = {}
    webinar = {}
    for j in range(len(names)):
        w_id = j + 51
        webinar['id'] = w_id
        webinar['name'] = names[j]
        webinar['description'] = descriptions[j]
        webinar['link'] = f'Webinar Link {w_id}'

        webinar['is_released'] = j <= len(names) // 2
        if webinar['is_released']:
            webinar['release_date'] = (datetime.datetime(2023,
                                                         12,
                                                         18,
                                                         hour=random.randint(12, 20))
                                       + datetime.timedelta(days=j))
            webinar['recording_link'] = f'Recording Link {w_id}'
            webinar['recording_release_date'] = webinar['release_date'] + datetime.timedelta(
                days=random.randint(1, 3)
            )
            webinar['closed'] = 0
            webinar['closed_at'] = None
        else:
            webinar['release_date'] = datetime.datetime(2024, 1, 27, hour=random.randint(12, 18)) + datetime.timedelta(
                days=j)
            webinar['recording_link'] = None
            webinar['recording_release_date'] = None
            webinar['closed'] = 0
            webinar['closed_at'] = None

      
        webinar['end_date'] = webinar['release_date'] + datetime.timedelta(hours=1,
                                                                           minutes=random.randint(0,59))
        webinar['is_free'] = j % 2 == 0
        webinar['price'] = 0 if webinar['is_free'] else random.randint(50, 200)

        webinar['added_at'] = webinar['release_date'] - datetime.timedelta(days=31)
        webinar['lecturer_id'] = random.randint(9, 35)
        webinar['translator_id'] = random.randint(1, 4) if random.randint(1, 5) == 1 else None
        webinar['language_id'] = 2 if webinar['translator_id'] is not None else 1
        webinars_table[w_id] = webinar.copy()
    return webinars_table


def generate_product(winfo):
    before = "SET IDENTITY_INSERT Products ON;"
    insert = f"INSERT INTO Products(ProductID, Price, AdvancePayment, ProductType, AddedAt, ClosedAt) VALUES ({winfo['id']}, {winfo['price']}, NULL, 'webinar', " \
           f"""'{winfo["added_at"]}', {format_nullable_stringlike(winfo['closed_at'])});"""
    after = "SET IDENTITY_INSERT Products OFF;"
    return before + "\n" + insert + "\n" + after


def generate_webinar(winfo):
    return f"""
INSERT INTO Webinars VALUES ({winfo['id']}, '{winfo['name']}', '{winfo['description']}',
'{winfo['release_date']}', '{winfo['end_date']}', {format_nullable_stringlike(winfo['recording_link'])}, '{winfo['link']}', {winfo['lecturer_id']},
{winfo['translator_id']}, {winfo['language_id']}, {format_nullable_stringlike(winfo['recording_release_date'])});
"""


def generate_participants(winfo):
    def generate_payment_sql(payment_id, user_id, payment_date, status):
        before = "SET IDENTITY_INSERT Payments ON;"
        afer = "SET IDENTITY_INSERT Payments OFF;"
        insert =  f"INSERT INTO Payments(PaymentID, UserID, ProductID, Price, Date, Status) VALUES ({payment_id}, {user_id}, {winfo['id']}, {winfo['price']}, " \
               f"'{payment_date}', '{status}');"
        return before + "\n" + insert + "\n" + afer

  
  
    def generate_webinar_participant_sql(webinar_participant_id, user_id, due_postponed_payment, full_price_payment_id, p_date):
        before = "SET IDENTITY_INSERT WebinarParticipants ON;"
        after = "SET IDENTITY_INSERT WebinarParticipants OFF;"
        insert = f"INSERT INTO WebinarParticipants(WebinarParticipantID, UserID, WebinarID, WebinarPrice, DuePostponedPayment, FullPricePaymentID, AddedAt) VALUES ({webinar_participant_id}, {user_id}, {winfo['id']}, " \
               f"{winfo['price']}, {format_nullable_stringlike(turn_none_into_null(due_postponed_payment))}, {full_price_payment_id}, '{p_date}' );"
        return before + "\n" + insert + "\n" + after

    def generate_webinar_attendance_sql(webinar_id, webinar_participant_id):
        wasPresent = 1 if random.randint(1, 10) <= 7  else 0
        return f"INSERT INTO WebinarsAttendence VALUES ({webinar_id}, {webinar_participant_id}, {wasPresent});"

    number_of_participants = random.randint(10, 30) if winfo['is_released'] else random.randint(0, 15)
    participants_ids = [get_new_participant_id() for _ in range(number_of_participants)]
    user_ids = get_n_user_ids(number_of_participants)

    winfo['participants'] = [
        {
            'id': participant_id,
            'user_id': user_id,
            'exception': random.randint(1, 10) == 1 and not winfo['is_free']
        }
        for user_id, participant_id in zip(user_ids, participants_ids)]

    instructions = []
    for participant in winfo['participants']:

        due_postponed_payment = (winfo['release_date'] + datetime.timedelta(days=random.randint(1, 30))
                                 if participant['exception'] else None)

        p_date = winfo['added_at'] + datetime.timedelta(days=random.randint(3, 7),
                                                                            hours=random.randint(3, 5))
      
        if participant['exception'] or winfo['is_free']:
            instructions.append(
                generate_webinar_participant_sql(participant['id'], participant['user_id'], due_postponed_payment,
                                                 'NULL',
                                                p_date)
            )
        else:
            payment_id = get_new_payment_id()
            instructions.append(
                generate_payment_sql(payment_id, participant['user_id'],
                                     p_date,
                                     'Successful')
            )

            if random.randint(1, 10) == 1:
                instructions.append(
                    generate_payment_sql(get_new_payment_id(), participant['user_id'],
                                         p_date,
                                         'Failed')
                )

            instructions.append(
                generate_webinar_participant_sql(participant['id'], participant['user_id'], due_postponed_payment,
                                                 payment_id,
                                                p_date)
            )

            if random.randint(1, 10) <= 8:
                instructions.append(
                    generate_webinar_attendance_sql(
                        winfo['id'],
                        participant['id']
                    )
                )

    return '\n'.join(instructions)


def generate_webinar_rules():
    """
    -- Table: RecordingAccessTime
    CREATE TABLE RecordingAccessTime (
    RecordingAcessTimeID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    WebinarID int  NULL,
    CONSTRAINT RecordingAccessTime_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT RecordingAccessTime_NumberOfDaysIsValid CHECK (NumberOfDays >= 0),
    CONSTRAINT RecordingAccessTime_pk PRIMARY KEY  (RecordingAcessTimeID) );
    """

    return f"INSERT INTO RecordingAccessTime VALUES ('2021-01-01', NULL, 30, NULL);"


def format_info_for_sql(info):
    for key in info:
        if info[key] is None:
            info[key] = 'NULL'
    return info


def turn_none_into_null(value):
    if value is None:
        return 'NULL'
    else:
        return value


def format_nullable_stringlike(nullable):
    if nullable == 'NULL':
        return 'NULL'
    else:
        return f"'{nullable}'"


print(f"""
BEGIN TRANSACTION;

BEGIN TRY
    -- Webinars
    {generate_webinars()}
    -- Webinar Rules
    {generate_webinar_rules()}
    -- If everything is successful, commit the transaction
    COMMIT;
END TRY
BEGIN CATCH
    -- If an error occurs, rollback the transaction
    ROLLBACK;
    PRINT 'Error occurred. Transaction rolled back.' + ERROR_MESSAGE();
END CATCH;

""")
