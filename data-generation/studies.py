import random
from datetime import datetime, timedelta

random.seed(42)

global_payment_id = 20_000
def new_payment_id():
  global global_payment_id
  global_payment_id += 1
  return global_payment_id


global_studies_product_id = 1_000
def new_product_id():
  global global_studies_product_id
  global_studies_product_id += 1
  return global_studies_product_id

def get_advance_payment(price):
  return (price) // 5

cities = [
    "Warsaw", "Krakow", "Gdansk", "Wroclaw", "Poznan", "Szczecin", "Lublin",
    "Katowice", "Bialystok", "Gdynia"
]
addresses = [
    "Aleja Jana Pawła II", "ul. Nowy Świat", "ul. Marszałkowska",
    "ul. Krakowska", "ul. Wojska Polskiego", "ul. Piłsudskiego",
    "ul. Mickiewicza", "ul. Słowackiego"
]

# studies_id : [field_id, start, end, max_students, price, language, semester]
all_studies = {}

# studies_id : [subject_id]
all_subjects = {}
reverse_subjects = {}

# subject_id : makeup_id
all_makeups = {}

# student_id : studies_id
all_students = {}
# studies_id : [student_id]
reverse_studies = {}

# studies_id : [(internship_id, start_date, company_name)]
all_internships = {}

# company_name : (country, city, postal_code, address)
internship_companies = {}

# subject_id : exam_id
all_exams = {}

online_sessions = set()
stationary_sessions = set()
public_sessions = set()

public_session_id = {}

# subject_id : [session_id]
all_sessions = {}

# public_session_id : price
public_session_price = {}

# public_session_participant : public_session_id
public_session_participants = {}

# key: session_id
session_data = {}

def format_nullable(nullable):
    nullable = str(nullable)
    if nullable == 'NULL':
        return 'NULL'
    else:
        return f"'{nullable}'"

def generate_fields_of_study():
  '''
    CREATE TABLE FieldsOfStudies (
        FieldOfStudiesID int  NOT NULL,
        Name nvarchar(max)  NOT NULL,
        Description nvarchar(max)  NOT NULL,
        CONSTRAINT FieldsOfStudies_pk PRIMARY KEY  (FieldOfStudiesID)
    );
    '''
  fields_of_study = {
      1: [
          "Informatyka",
          "Badanie obliczeń, algorytmów, języków programowania, inżynierii oprogramowania, sztucznej inteligencji i powiązanych tematów."
      ],
      2: [
          "Prawo",
          "Badanie reguł i zasad rządzących postępowaniem i relacjami jednostek, grup i państw, a także stosowanie i interpretacja norm i procedur prawnych w różnych kontekstach i przypadkach."
      ],
      3: [
          "Medycyna",
          "Nauka o zdrowiu, chorobach i leczeniu oraz diagnozowaniu, leczeniu i zapobieganiu różnym schorzeniom i zaburzeniom medycznym."
      ],
      4: [
          "Inżynieria",
          "Zastosowanie naukowych, matematycznych i technologicznych zasad i metod do projektowania, tworzenia, ulepszania i utrzymywania różnych systemów, produktów i rozwiązań dla różnych problemów i potrzeb."
      ],
      5: [
          "Ekonomia",
          "Badanie, w jaki sposób ludzie, firmy i rządy dokonują wyborów i alokują ograniczone zasoby oraz w jaki sposób wpływają na nie różne czynniki, takie jak zachęty, rynki, polityka i instytucje."
      ],
  }
  insertions = []
  for field_of_study_id in range(1, 6):
    insertions.append("SET IDENTITY_INSERT FieldsOfStudies ON;")
    insertions.append(
        f"INSERT INTO FieldsOfStudies (FieldOfStudiesID, Name, Description) VALUES ({field_of_study_id}, '{fields_of_study[field_of_study_id][0]}', '{fields_of_study[field_of_study_id][1]}');"
    )
    insertions.append("SET IDENTITY_INSERT FieldsOfStudies OFF;")
  return insertions


def generate_studies():
  '''
    CREATE TABLE Studies (
        StudiesID int  NOT NULL,
        Name nvarchar(100)  NOT NULL,
        Description nvarchar(max)  NOT NULL,
        CoordinatorID int  NOT NULL,
        StartDate Date  NOT NULL,
        EndDate Date  NOT NULL,
        MaxStudents int  NOT NULL,
        LanguageID int  NOT NULL,
        Semester int  NOT NULL,
        FieldOfStudiesID int  NOT NULL,
        SemesterNumber int  NOT NULL,
        CONSTRAINT Studies_DateIntervalIsValid CHECK (StartDate < EndDate),
        CONSTRAINT Studies_MaxStudentsIsValid CHECK (MaxStudents > 0),
        CONSTRAINT Studies_SemesterIsValid CHECK (SemesterNumber >= 1),
        CONSTRAINT Studies_pk PRIMARY KEY  (StudiesID)
    );
    '''
  studies = {
      1: {
          "Sztuczna Inteligencja": [
              "Specjalizacja skupiająca się na tworzeniu systemów i maszyn, które mogą wykonywać zadania normalnie wymagające ludzkiej inteligencji, takie jak rozumowanie, uczenie się, podejmowanie decyzji i przetwarzanie języka naturalnego.",
              1
          ],
          "Cyberbezpieczeństwo": [
              "Specjalizacja koncentrująca się na ochronie informacji i systemów przed nieautoryzowanym dostępem, wykorzystaniem, modyfikacją lub uszkodzeniem oraz opracowywaniu metod i narzędzi do wykrywania, zapobiegania i reagowania na cyberataki.",
              1
          ],
          "Informatyka Stosowana": [
              "Specjalizacja, która koncentruje się na praktycznym zastosowaniu zasad i metod informatyki do rozwiązywania rzeczywistych problemów i tworzenia innowacyjnych rozwiązań.",
              1
          ]
      },
      2: {
          "Prawo karne": [
              "Specjalizacja, która koncentruje się na ściganiu i obronie osób oskarżonych o popełnienie przestępstw oraz stosowaniu i interpretacji przepisów, zasad i procedur karnych.",
              1
          ],
          "Prawo korporacyjne": [
              "Specjalizacja, która koncentruje się na tworzeniu, zarządzaniu i regulacji korporacji i innych podmiotów gospodarczych, a także kwestiach prawnych i transakcjach związanych z ich działalnością, takich jak umowy, fuzje, przejęcia i papiery wartościowe.",
              1
          ],
          "Prawo ochrony środowiska": [
              "Specjalizacja, która koncentruje się na ochronie i zarządzaniu środowiskiem naturalnym i jego zasobami, a także na opracowywaniu i egzekwowaniu przepisów, polityk i regulacji dotyczących ochrony środowiska.",
              1
          ]
      },
      3: {
          "Kardiologia": [
              "Specjalizacja, która koncentruje się na diagnozowaniu i leczeniu chorób i zaburzeń serca i naczyń krwionośnych, takich jak choroba wieńcowa, zaburzenia rytmu serca, niewydolność serca i wrodzone wady serca.",
              1
          ],
          "Neurologia": [
              "Specjalizacja skupiająca się na diagnozowaniu i leczeniu chorób i zaburzeń mózgu i układu nerwowego, takich jak udar, padaczka, choroba Parkinsona, choroba Alzheimera i stwardnienie rozsiane.",
              1
          ],
          "Chirurgia": [
              "Specjalizacja, która koncentruje się na stosowaniu procedur operacyjnych w leczeniu różnych schorzeń i urazów, takich jak guzy, urazy, infekcje i deformacje. Chirurgię można podzielić na kilka podspecjalności, takich jak chirurgia ogólna, chirurgia ortopedyczna, chirurgia naczyniowa i chirurgia plastyczna.",
              1
          ]
      },
      4: {
          "Inżynieria mechaniczna": [
              "Specjalizacja, która koncentruje się na projektowaniu, analizie i produkcji różnych maszyn, systemów i urządzeń związanych z ruchem, siłą i energią, takich jak silniki, pojazdy, roboty i turbiny.",
              1
          ],
          "Inżynieria elektryczna": [
              "Specjalizacja, która koncentruje się na badaniu i stosowaniu elektryczności, elektroniki i elektromagnetyzmu oraz opracowywaniu i ulepszaniu różnych urządzeń i systemów elektrycznych i elektronicznych, takich jak obwody, czujniki, mikroprocesory i sieci komunikacyjne.",
              1
          ],
          "Inżynieria lądowa": [
              "Specjalizacja, która koncentruje się na planowaniu, budowie i utrzymaniu różnych struktur i infrastruktury, takich jak budynki, mosty, drogi, tamy i lotniska.",
              1
          ]
      },
      5: {
          "Ekonomia behawioralna": [
              "Specjalizacja, która koncentruje się na badaniu i analizie czynników psychologicznych, społecznych i poznawczych, które wpływają na decyzje ekonomiczne i działania jednostek i grup oraz na to, w jaki sposób odbiegają one od modelu racjonalnego wyboru.",
              1
          ],
          "Ekonomia międzynarodowa": [
              "Specjalizacja, która koncentruje się na badaniu i analizie interakcji gospodarczych i relacji między różnymi krajami i regionami oraz wpływu handlu, migracji, kursów wymiany i globalizacji na gospodarkę.",
              1
          ],
          "Ekonomia publiczna": [
              "Specjalizacja, która koncentruje się na badaniu i analizie roli i wpływu rządu i polityk publicznych na gospodarkę, takich jak podatki, wydatki publiczne, regulacje i dobrobyt.",
              1
          ]
      }
  }
  start_dates = [datetime(2023, 2, 26), datetime(2023, 10, 2)]
  end_dates = [datetime(2023, 9, 10), datetime(2024, 2, 18)]
  insertions = []

  for studies_id in range(1, 16):
    coordinator_id = random.randint(9, 35)

    field_of_study_id = random.randint(1, 5)
    name = list(studies[field_of_study_id].keys())[random.randint(0, 2)]
    description = studies[field_of_study_id][name][0]
    semester_number = studies[field_of_study_id][name][1]

    # modifier = (semester_number - 1)
    # start_date = start_dates[modifier % 2] - timedelta(modifier * 365)
    # end_date = end_dates[modifier % 2] - timedelta(modifier * 365)
    
    modifier = studies_id
    start_date = start_dates[modifier % 2]
    end_date = end_dates[modifier % 2]

    max_students = random.randint(60, 100)
    language_id = random.randint(1, 3)

    price = random.randint(3_000, 10_0000)
    advance_payment = get_advance_payment(price)
    closed_at = start_date if start_date < datetime.now()  else 'NULL'
    added_at = start_date - timedelta(days=90)

    insertions.append("SET IDENTITY_INSERT Products ON;")
    insertions.append(
       f"INSERT INTO Products(ProductID, Price, AdvancePayment, ProductType, AddedAt, ClosedAt)" +
      "VALUES ({}, {}, {}, '{}', {}, {});".format(studies_id,
                                                price,
                                                advance_payment,
                                                'studies',
                                                format_nullable(added_at),
                                                format_nullable(closed_at))
                                                
                                                
    ) 
    insertions.append("SET IDENTITY_INSERT Products OFF;")
    
    insertions.append(
        f"INSERT INTO Studies (StudiesID, Name, Description, CoordinatorID, StartDate, EndDate, MaxStudents, LanguageID, FieldOfStudiesID, SemesterNumber) VALUES ('{studies_id}', '{name}', '{description}', '{coordinator_id}', '{start_date.strftime('%Y-%m-%d %H:%M:%S')}', '{end_date.strftime('%Y-%m-%d %H:%M:%S')}', '{max_students}', '{language_id}', '{field_of_study_id}', '{semester_number}');"
    )


    studies[field_of_study_id][name] = [description, semester_number + 1]
    price = round(random.uniform(1000, 10000), 2)
    all_studies[studies_id] = [
        field_of_study_id, start_date, end_date, max_students, price,
        language_id, semester_number
    ]

  return insertions


def generate_subjects():
  '''
CREATE TABLE Subjects (
    SubjectID int  NOT NULL,
    StudiesID int  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CoordinatorID int  NOT NULL,
    SubjectName nvarchar(max)  NOT NULL,
    CONSTRAINT SubjectID PRIMARY KEY  (SubjectID)
);
 
    '''
  subjects = {
      1: [
          "Wprowadzenie do programowania - Kurs ten uczy podstawowych pojęć i umiejętności programowania, takich jak zmienne, typy danych, struktury kontrolne, funkcje i tablice, przy użyciu języka programowania wysokiego poziomu, takiego jak Python lub Java.",
          "Struktury danych i algorytmy - Kurs ten wprowadza powszechne struktury danych i algorytmy stosowane w informatyce, takie jak listy, stosy, kolejki, drzewa, grafy, sortowanie, wyszukiwanie i haszowanie, a także ich zastosowania, analizę i implementację.",
          "Systemy baz danych - Kurs obejmuje zasady i techniki projektowania, modelowania i zarządzania bazami danych, takie jak algebra relacyjna, SQL, normalizacja, indeksowanie, transakcje, współbieżność i bezpieczeństwo.",
          "Systemy operacyjne - Kurs ten bada projektowanie i wdrażanie systemów operacyjnych, takich jak procesy, wątki, planowanie, synchronizacja, zarządzanie pamięcią, systemy plików, I/O i wirtualizacja.",
          "Sieci komputerowe - Kurs ten analizuje architekturę i protokoły sieci komputerowych, takie jak model OSI, TCP/IP, routing, przełączanie, kontrola zatorów, sieci bezprzewodowe i bezpieczeństwo.",
          "Tworzenie stron internetowych - Kurs ten uczy podstaw tworzenia stron internetowych, takich jak HTML, CSS, JavaScript, DOM, jQuery, AJAX, PHP i MySQL, a także tworzenia dynamicznych i interaktywnych aplikacji internetowych."
      ],
      2: [
          "Prawo konstytucyjne - Kurs obejmuje zasady i doktryny prawa konstytucyjnego, takie jak podział władzy, federalizm, kontrola sądowa oraz ochrona podstawowych praw i wolności.",
          "Prawo karne - Kurs obejmuje ogólne zasady i elementy prawa karnego, takie jak natura i źródła prawa karnego, klasyfikacja i rodzaje przestępstw, mens rea i actus reus oraz obrona i usprawiedliwienie.",
          "Prawo umów - Kurs ten obejmuje tworzenie, interpretację i egzekwowanie umów, takich jak oferta i akceptacja, wynagrodzenie, warunki, naruszenie i środki zaradcze oraz czynniki unieważniające.",
          "Prawo deliktów - Kurs ten obejmuje odpowiedzialność cywilną za bezprawne czyny, które powodują szkody lub obrażenia u innych osób, takie jak zaniedbanie, uciążliwość, zniesławienie, wtargnięcie i odpowiedzialność zastępcza.",
          "Prawo własności - Kurs ten obejmuje prawa i obowiązki związane z posiadaniem, użytkowaniem i przenoszeniem własności, takie jak nieruchomości, własność osobista, własność intelektualna i fundusze powiernicze.",
          "Prawo międzynarodowe - Kurs ten obejmuje reguły i zasady prawne, które regulują stosunki i interakcje między państwami i innymi podmiotami międzynarodowymi, takie jak źródła i przedmioty prawa międzynarodowego, jurysdykcja i immunitet, odpowiedzialność państwa i prawa człowieka, a także użycie siły i pokojowe rozstrzyganie sporów."
      ],
      3: [
          "Anatomia - Kurs obejmuje strukturę i organizację ludzkiego ciała, w tym kości, mięśnie, narządy i układy, a także wykorzystanie różnych metod i narzędzi, takich jak sekcja, mikroskopia i obrazowanie.",
          "Fizjologia - Kurs ten obejmuje funkcje i mechanizmy ludzkiego ciała, takie jak krążenie, oddychanie, trawienie, wydalanie i rozmnażanie, a także regulację i integrację różnych procesów fizjologicznych.",
          "Patologia - Kurs ten obejmuje przyczyny i skutki chorób i zaburzeń, takich jak infekcje, stany zapalne, nowotwory, zwyrodnienia i urazy, a także diagnostykę i klasyfikację różnych stanów patologicznych.",
          "Farmakologia - Kurs ten obejmuje zasady i praktyki działania leków i terapii, takie jak źródła, właściwości, skutki i interakcje leków oraz stosowanie różnych leków w różnych warunkach i celach.",
          "Chirurgia - Ten kurs obejmuje zasady i techniki procedur operacyjnych w leczeniu różnych schorzeń i urazów, takich jak guzy, urazy, infekcje i deformacje, a także wykorzystanie różnych instrumentów i sprzętu, takich jak skalpele, szwy i znieczulenie.",
          "Pediatria - Kurs ten obejmuje zdrowie i rozwój dzieci i młodzieży oraz diagnozowanie i leczenie różnych schorzeń i zaburzeń pediatrycznych, takich jak wzrost, odżywianie, szczepienia, infekcje, alergie i wady wrodzone."
      ],
      4: [
          "Inżynieria mechaniczna - Kurs ten obejmuje projektowanie, analizę i produkcję różnych maszyn, systemów i urządzeń związanych z ruchem, siłą i energią, takich jak silniki, pojazdy, roboty i turbiny.",
          "Inżynieria elektryczna - Kurs ten obejmuje badanie i zastosowanie elektryczności, elektroniki i elektromagnetyzmu, a także rozwój i ulepszanie różnych urządzeń i systemów elektrycznych i elektronicznych, takich jak obwody, czujniki, mikroprocesory i sieci komunikacyjne.",
          "Inżynieria chemiczna - Kurs ten obejmuje zastosowanie chemii, fizyki i matematyki do produkcji i przekształcania różnych materiałów, substancji i produktów, takich jak paliwa, tworzywa sztuczne, leki i żywność.",
          "Inżynieria biomedyczna - Kurs ten obejmuje integrację inżynierii i medycyny w celu tworzenia i ulepszania różnych urządzeń, systemów i rozwiązań dla opieki zdrowotnej i badań biomedycznych, takich jak implanty, protetyka, obrazowanie, diagnostyka i terapia.",
          "Inżynieria środowiska - Kurs ten obejmuje wykorzystanie zasad i metod inżynieryjnych w celu ochrony i poprawy środowiska naturalnego i zdrowia ludzkiego, takich jak uzdatnianie wody, gospodarka odpadami, kontrola zanieczyszczeń i energia odnawialna.",
          "Podstawy inżynierii - Zasady i umiejętności inżynieryjne, takie jak projektowanie inżynieryjne, rozwiązywanie problemów, komunikacja, praca zespołowa, etyka i profesjonalizm."
      ],
      5: [
          "Mikroekonomia - Ta klasa obejmuje badanie i analizę indywidualnych zachowań i interakcji podmiotów gospodarczych, takich jak konsumenci, producenci i rynki, oraz tego, jak reagują one na różne zachęty, ceny i polityki.",
          "Makroekonomia - Klasa ta obejmuje badanie i analizę zagregowanych zachowań i wyników gospodarki, takich jak wzrost gospodarczy, inflacja, bezrobocie i handel międzynarodowy.",
          "Ekonometria - Ta klasa obejmuje zastosowanie metod statystycznych i modeli do testowania i szacowania różnych teorii ekonomicznych i relacji, a także wykorzystanie różnych źródeł danych i narzędzi programowych, takich jak Stata, R i EViews.",
          "Wprowadzenie do ekonomii rozwoju - Ta klasa obejmuje badanie i analizę rozwoju gospodarczego i wzrostu różnych krajów i regionów, a także przyczyny i konsekwencje ubóstwa, nierówności i niedorozwoju.",
          "Wprowadzenie do ekonomii międzynarodowej - Ta klasa obejmuje badanie i analizę interakcji gospodarczych i relacji między różnymi krajami i regionami oraz wpływu handlu, migracji, kursów wymiany i globalizacji na gospodarkę.",
          "Wprowadzenie do ekonomii publicznej - Klasa ta obejmuje badanie i analizę roli i wpływu rządu i polityk publicznych na gospodarkę, takich jak podatki, wydatki publiczne, regulacje i dobrobyt."
      ]
  }
  subject_id = 1
  insertions = []
  for studies_id in all_studies.keys():
    field_id = all_studies[studies_id][0]
    for i in range(3):
      description = random.choice(subjects[field_id])
      subject_name = description.split(" - ")[0]
      coordinator_id = random.randint(9, 35)
      
      insertions.append("SET IDENTITY_INSERT Subjects ON;")
      insertions.append(
          f"INSERT INTO Subjects (SubjectID, StudiesID, Description, CoordinatorID, SubjectName) VALUES ('{subject_id}', '{studies_id}', '{description}', '{coordinator_id}', '{subject_name}');"
      )
      insertions.append("SET IDENTITY_INSERT Subjects OFF;")
      all_subjects[studies_id] = all_subjects.get(studies_id,
                                                  []) + [subject_id]
      reverse_subjects[subject_id] = studies_id
      subject_id += 1
  return insertions


def generate_subject_make_up_possibilities():
  '''
    CREATE TABLE SubjectMakeUpPossibilities (
        SubjectID int  NOT NULL,
        ProductID int  NOT NULL,
        AttendanceValue int  NOT NULL,
        CONSTRAINT SubjectMakeUpPossibilities_pk PRIMARY KEY  (SubjectID,ProductID)
    );
    '''
  insertions = []
  for studies_id in all_subjects.keys():
    for subject_id in all_subjects[studies_id]:
      product_id = random.randint(16, 70)
      attendance_value = random.randint(1, 2)
      insertions.append(
          f"INSERT INTO SubjectMakeUpPossibilities (SubjectID, ProductID, AttendanceValue) VALUES ('{subject_id}', '{product_id}', {attendance_value});"
      )
      all_makeups[subject_id] = product_id
  return insertions


def generate_exams():
  '''
    CREATE TABLE Exams (
        ExamID int  NOT NULL,
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
    '''
  insertions = []
  country = "Poland"
  for exam_id in range(1, 46):
    subject_id = exam_id
    end_date = all_studies[reverse_subjects[subject_id]][2]
    start_date = end_date - timedelta(random.randint(5, 14))
    city = random.choice(cities)
    postal_code = f"{random.randint(10, 99)}-{random.randint(100, 999)}"
    address = random.choice(addresses) + " " + str(random.randint(3, 100))
    
    insertions.append("SET IDENTITY_INSERT Exams ON;")
    insertions.append(
        f"INSERT INTO Exams (ExamID, SubjectID, StartDate, EndDate, Country, City, PostalCode, Address) VALUES ('{exam_id}', '{subject_id}', '{start_date.strftime('%Y-%m-%d %H:%M:%S')}', '{end_date.strftime('%Y-%m-%d %H:%M:%S')}', '{country}', '{city}', '{postal_code}', '{address}');"
    )
    insertions.append("SET IDENTITY_INSERT Exams OFF;")
    all_exams[subject_id] = exam_id
  return insertions


def generate_internships():
  '''
    CREATE TABLE Internships (
        InternshipID int  NOT NULL,
        StudiesID int  NOT NULL,
        Description nvarchar(max)  NOT NULL,
        StartDate date  NOT NULL,
        EndDate date  NOT NULL,
        CONSTRAINT Internships_DateIntervalIsValid CHECK (StartDate < EndDate),
        CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
    );
    '''
  descriptions = {
      1:
      [("Web Developer Intern w Zapify, startupie tworzącym aplikacje internetowe dla małych firm. Będziesz odpowiedzialny za rozwój funkcji front-end i back-end, testowanie i debugowanie kodu oraz współpracę z innymi programistami i projektantami. Powinieneś mieć doświadczenie z HTML, CSS, JavaScript i co najmniej jednym frameworkiem internetowym, takim jak React, Angular lub Django.",
        "Zapify"),
       ("Data Analyst Intern w InSight, firmie dostarczającej rozwiązania oparte na danych dla różnych branż. Będziesz zaangażowany w zbieranie, czyszczenie i analizowanie danych z różnych źródeł, tworzenie wizualizacji i raportów oraz prezentowanie spostrzeżeń klientom i interesariuszom. Powinieneś znać SQL, Python, R i narzędzia do analizy danych, takie jak Excel, Tableau lub Power BI.",
        "InSight"),
       ("Stażysta ds. uczenia maszynowego w Brainy, laboratorium badawczym zajmującym się sztuczną inteligencją i neuronauką. Będziesz pracować nad najnowocześniejszymi projektami, które wykorzystują techniki uczenia maszynowego do rozwiązywania rzeczywistych problemów, takich jak przetwarzanie języka naturalnego, wizja komputerowa lub rozpoznawanie mowy. Powinieneś mieć solidne doświadczenie w matematyce, statystyce i programowaniu oraz znajomość frameworków uczenia maszynowego, takich jak TensorFlow, PyTorch lub Scikit-learn.",
        "Brainy")],
      2:
      [("Stażysta ds. badań prawnych w Lexicon, firmie zajmującej się technologiami prawnymi, która opracowuje oprogramowanie dla prawników i kancelarii prawnych. Będziesz prowadzić badania prawne na różne tematy, takie jak umowy, własność intelektualna lub prywatność, a także pisać notatki, briefy i artykuły. Powinieneś mieć doskonałe umiejętności pisania i wyszukiwania informacji oraz znajomość prawnych baz danych i oprogramowania.",
        "Lexicon"),
       ("Stażysta ds. praw człowieka w Justice Now, organizacji pozarządowej działającej na rzecz praw człowieka i sprawiedliwości społecznej. Będziesz pomagać w monitorowaniu praw człowieka, raportowaniu i rzecznictwie, a także zapewniać wsparcie prawne ofiarom naruszeń praw człowieka. Powinieneś pasjonować się prawami człowieka i sprawiedliwością społeczną oraz znać międzynarodowe prawo i mechanizmy dotyczące praw człowieka.",
        "Justice Now"),
       ("Stażysta ds. prawa korporacyjnego w Global Ventures, międzynarodowej korporacji działającej w różnych sektorach, takich jak energetyka, finanse czy technologia. Będziesz pracować nad sprawami z zakresu prawa korporacyjnego, takimi jak fuzje i przejęcia, ład korporacyjny lub zgodność z przepisami, a także sporządzanie i przeglądanie umów, porozumień i polityk. Powinieneś mieć duże zainteresowanie prawem korporacyjnym i biznesem oraz doświadczenie w transakcjach i dokumentach z zakresu prawa korporacyjnego.",
        "Global Ventures")],
      3:
      [("Stażysta ds. badań klinicznych w MediX, firmie biotechnologicznej, która opracowuje innowacyjne leki i terapie na różne choroby. Będziesz zaangażowany w prowadzenie badań klinicznych, zbieranie i analizowanie danych oraz przygotowywanie raportów i manuskryptów. Powinieneś mieć wykształcenie w dziedzinie biologii, chemii lub medycyny oraz doświadczenie w zakresie metod badań klinicznych i etyki.",
        "MediX"),
       ("Stażysta ds. zarządzania opieką zdrowotną w CareNet, sieci opieki zdrowotnej, która zapewnia wysokiej jakości i przystępne cenowo usługi opieki zdrowotnej dla różnych społeczności. Będziesz pracować nad projektami zarządzania opieką zdrowotną, takimi jak poprawa satysfakcji pacjentów, optymalizacja wydajności operacyjnej lub ulepszanie cyfrowych rozwiązań zdrowotnych. Powinieneś interesować się zarządzaniem i polityką opieki zdrowotnej oraz posiadać umiejętności w zakresie komunikacji, przywództwa i rozwiązywania problemów.",
        "CareNet"),
       ("Stażysta ds. edukacji medycznej w EduMed, platformie internetowej oferującej kursy i zasoby z zakresu edukacji medycznej dla studentów i profesjonalistów. Będziesz tworzyć i weryfikować treści związane z edukacją medyczną, takie jak wykłady, quizy lub symulacje, a także udzielać informacji zwrotnych i wsparcia osobom uczącym się. Powinieneś mieć pasję do edukacji medycznej i uczenia się oraz znajomość tematów i terminologii medycznej.",
        "EduMed")],
      4:
      [("Robotics Engineer Intern w RoboCo, firmie, która projektuje i buduje roboty do różnych celów, takich jak rozrywka, edukacja czy bezpieczeństwo. Będziesz odpowiedzialny za rozwój i testowanie systemów robotycznych, programowanie i debugowanie kodu oraz integrację komponentów sprzętowych i oprogramowania. Powinieneś mieć doświadczenie z robotyką, elektroniką i językami programowania, takimi jak C++, Python lub ROS.",
        "RoboCo"),
       ("Inżynier budownictwa Stażysta w BuildIt, firmie świadczącej usługi inżynierii lądowej dla różnych projektów, takich jak mosty, drogi czy budynki. Będziesz zaangażowany w planowanie, projektowanie i konstruowanie struktur cywilnych, przeprowadzanie badań i inspekcji na miejscu oraz przygotowywanie raportów i rysunków. Powinieneś posiadać wiedzę na temat zasad inżynierii lądowej, metod i oprogramowania, takiego jak AutoCAD, Revit lub MATLAB.",
        "BuildIt"),
       ("Inżynier chemik - staż w Chemix, firmie produkującej i sprzedającej produkty chemiczne dla różnych branż, takich jak farmaceutyczna, kosmetyczna czy spożywcza. Będziesz pracować nad procesami inżynierii chemicznej, takimi jak synteza, separacja lub reakcja, optymalizacja i skalowanie produkcji oraz zapewnianie standardów jakości i bezpieczeństwa. Powinieneś mieć wykształcenie w dziedzinie chemii, fizyki lub matematyki oraz znajomość oprogramowania do inżynierii chemicznej, takiego jak Aspen, ChemCAD lub COMSOL.",
        "Chemix")],
      5:
      [("Economic Analyst Intern w Econix, firmie zajmującej się analizą ekonomiczną i doradztwem dla różnych klientów, takich jak rządy, firmy czy organizacje non-profit. Będziesz zaangażowany w prowadzenie badań ekonomicznych, zbieranie i interpretowanie danych oraz tworzenie raportów i prezentacji. Powinieneś mieć doświadczenie w ekonomii, statystyce lub matematyce oraz umiejętności w Excelu, Stata lub R.",
        "Econix"),
       ("Inżynier finansowy Stażysta w Finex, firmie zajmującej się opracowywaniem i wdrażaniem modeli finansowych i algorytmów do różnych zastosowań, takich jak zarządzanie ryzykiem, optymalizacja portfela lub handel. Będziesz pracować nad projektowaniem i testowaniem rozwiązań inżynierii finansowej, programowaniem i debugowaniem kodu oraz współpracować z innymi inżynierami i analitykami. Powinieneś mieć duże zainteresowanie finansami i inżynierią oraz doświadczenie z Python, C++ lub MATLAB.",
        "Finex"),
       ("Stażysta ds. rozwoju gospodarczego w EcoDev, firmie wspierającej rozwój gospodarczy i inicjatywy społeczne na rynkach wschodzących. Będziesz pomagać w zarządzaniu projektami, monitorowaniu i ocenie oraz angażowaniu interesariuszy. Powinieneś mieć pasję do rozwoju gospodarczego i wpływu społecznego oraz znajomość zagadnień rozwoju międzynarodowego i najlepszych praktyk.",
        "EcoDev")]
  }
  insertions = []
  internship_id = 1
  for studies_id in all_studies.keys():
    field_id = all_studies[studies_id][0]
    studies_start_date = all_studies[studies_id][1]
    for description, company_name in descriptions[field_id]:
      start_date = studies_start_date + timedelta(random.randint(0, 240))
      end_date = start_date + timedelta(14)
      insertions.append("SET IDENTITY_INSERT Internships ON;")
      insertions.append(
          f"INSERT INTO Internships (InternshipID, StudiesID, Description, StartDate, EndDate) VALUES ('{internship_id}', '{studies_id}', '{description}', '{start_date.strftime('%Y-%m-%d %H:%M:%S')}', '{end_date.strftime('%Y-%m-%d %H:%M:%S')}');"
      )
      insertions.append("SET IDENTITY_INSERT Internships OFF;")
      all_internships[studies_id] = all_internships.get(studies_id, [])
      all_internships[studies_id].append(
          (internship_id, start_date, company_name))
      internship_id += 1
  return insertions


def generate_students():
  '''
CREATE TABLE Students (
    StudentID int  NOT NULL,
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
    Payments_PaymentID int  NOT NULL,
    CONSTRAINT Students_PriceIsValid CHECK (StudiesPrice > 0),
    CONSTRAINT Students_EntryFeeIsValid CHECK (EntryFee > 0 AND EntryFee < StudiesPrice),
    CONSTRAINT Students_pk PRIMARY KEY  (StudentID)
);
    '''
  insertions = []
  for student_id in range(1, 51):
    user_id = random.randint(41, 299)
    studies_id = random.choice(list(all_studies.keys()))

    field, start_date, end_date, max_students, studies_price, language_id, semester = all_studies[
        studies_id]
    while max_students == 0:
      studies_id = random.choice(list(all_studies.keys()))
      field, start_date, end_date, max_students, studies_price, language_id, semester = all_studies[
          studies_id]

    entry_fee = get_advance_payment(studies_price)
    due_postponed_payment = random.choice([
        "NULL",
        (start_date - timedelta(3) +
         timedelta(random.randint(1, 10))).strftime('%Y-%m-%d %H:%M:%S')
    ])

    
    entry_fee_payment_date = start_date - timedelta(days=30+random.randint(0,7))
    if due_postponed_payment == "NULL":
      # dodajemy płatności
      entry_fee_payment_id = new_payment_id()

      
      insertions.append("SET IDENTITY_INSERT Payments ON;")
      insertions.append(
        f"INSERT INTO Payments (PaymentID, UserID, ProductID, Price, Date, Status)VALUES ({entry_fee_payment_id}, {user_id}, {studies_id}, {entry_fee}, " \
        f"'{entry_fee_payment_date}', 'successful');"
      )
      insertions.append("SET IDENTITY_INSERT Payments OFF;")
    
      remaining_payment_id = new_payment_id()
      remaining_payment_date = start_date - timedelta(days=10+random.randint(0,7))

      
      insertions.append("SET IDENTITY_INSERT Payments ON;")
      insertions.append(
        f"INSERT INTO Payments (PaymentID, UserID, ProductID, Price, Date, Status)VALUES ({remaining_payment_id}, {user_id}, {studies_id}, {studies_price-entry_fee}, " \
        f"'{entry_fee_payment_date}', 'successful');"
      )
      insertions.append("SET IDENTITY_INSERT Payments OFF;")
    else:
      entry_fee_payment_id = "NULL"
      remaining_payment_id = "NULL"
    


    
    insertions.append("SET IDENTITY_INSERT Students ON;")
    insertions.append(
        f"INSERT INTO Students (StudentID, UserID, StudiesID, StudiesPrice, EntryFee, DuePostponedPayment, EntryFeePaymentID, RemainingPaymentID, AddedAt) VALUES ('{student_id}', '{user_id}', '{studies_id}', '{studies_price}', '{entry_fee}', {format_nullable(due_postponed_payment)}, {entry_fee_payment_id}, {remaining_payment_id}, '{entry_fee_payment_date}');"
    )
    
    insertions.append("SET IDENTITY_INSERT Students OFF;")

    semester = random.randint(1,3) # może do poprawy
    all_studies[studies_id] = [
        field, start_date, end_date, max_students - 1, studies_price,
        language_id, semester
    ]
    all_students[student_id] = studies_id
    reverse_studies[studies_id] = reverse_studies.get(studies_id,
                                                      []) + [student_id]

  return insertions


def generate_internship_details():
  '''
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
    '''
  insertions = []
  for student_id in all_students.keys():
    studies_id = all_students[student_id]
    internship_id, start_date, company_name = random.choice(
        all_internships[studies_id])
    completed_at =  (start_date + timedelta(14)).strftime('%Y-%m-%d %H:%M:%S')
    if start_date + timedelta(days=14) > datetime.now():
      completed_at = "NULL"
    
    completed = int(completed_at == "NULL")

    if company_name in internship_companies.keys():
      country, city, postal_code, address = internship_companies[company_name]
    else:
      country = "Poland"
      city = random.choice(cities)
      postal_code = f"{random.randint(10, 99)}-{random.randint(100, 999)}"
      address = random.choice(addresses) + " " + str(random.randint(3, 100))
      internship_companies[company_name] = (country, city, postal_code,
                                            address)

    insertions.append(
        f"INSERT INTO InternshipDetails (StudentID, IntershipID, CompletedAt, Completed, CompanyName, City, Country, PostalCode, Address) VALUES ('{student_id}', '{internship_id}', {format_nullable(completed_at)}, '{completed}', '{company_name}', '{city}', '{country}', '{postal_code}', '{address}');"
    )

  return insertions


def generate_min_attendance_percentage_to_pass_internship():
  '''
    CREATE TABLE MinAttendancePercentageToPassInternship (
        MinAttendancePercentageToPassInternshipID int  NOT NULL,
        StartDate datetime  NOT NULL,
        EndDate datetime  NULL,
        AttendancePercentage decimal(6,4)  NOT NULL,
        InternshipID int  NULL,
        CONSTRAINT MinAttendancePercentageToPassInternship_DateIntervalIsValid CHECK (StartDate < EndDate),
        CONSTRAINT MinAttendancePercentageToPassInternship_PercentageIsValid CHECK (AttendancePercentage BETWEEN 0 AND 1.0),
        CONSTRAINT MinAttendancePercentageToPassInternship_pk PRIMARY KEY  (MinAttendancePercentageToPassInternshipID)
    );
    '''
  insertions = []
  min_attendance_percentage_to_pass_internship_id = 1
  
  insertions.append("SET IDENTITY_INSERT MinAttendancePercentageToPassInternship ON;")
  insertions.append(
      f"INSERT INTO MinAttendancePercentageToPassInternship (MinAttendancePercentageToPassInternshipID, StartDate, EndDate, AttendancePercentage, InternshipID) VALUES ('{min_attendance_percentage_to_pass_internship_id}', '2020-01-01', NULL, '1.0', NULL);"
  )
  insertions.append("SET IDENTITY_INSERT MinAttendancePercentageToPassInternship OFF;")
  
  # for student_id in all_students.keys():
  #   studies_id = all_students[student_id]
  #   for internship_id, start_date, company_name in all_internships[studies_id]:
  #     end_date = start_date + timedelta(14)
  #     attendance_percentage = 1.0
      
  #     insertions.append("SET IDENTITY_INSERT MinAttendancePercentageToPassInternship ON;")
  #     insertions.append(
  #         f"INSERT INTO MinAttendancePercentageToPassInternship (MinAttendancePercentageToPassInternshipID, StartDate, EndDate, AttendancePercentage, InternshipID) VALUES ('{min_attendance_percentage_to_pass_internship_id}', '{start_date.strftime('%Y-%m-%d %H:%M:%S')}', '{end_date.strftime('%Y-%m-%d %H:%M:%S')}', '{attendance_percentage}', '{internship_id}');"
  #     )
  #     insertions.append("SET IDENTITY_INSERT MinAttendancePercentageToPassInternship OFF;")
  #     min_attendance_percentage_to_pass_internship_id += 1
  return insertions


def generate_days_in_internship():
  """
    CREATE TABLE DaysInInternship (
        DaysInInternshipID int  NOT NULL IDENTITY,
        StartDate datetime  NOT NULL,
        EndDate datetime  NULL,
        NumberOfDays int  NOT NULL,
        InternshipID int  NULL,
        CONSTRAINT DaysInInternship_DateIntervalIsValid CHECK (StartDate < EndDate),
        CONSTRAINT DaysInInternship_NumberOfDaysIsValid CHECK (NumberOfDays > 0),
        CONSTRAINT DaysInInternship_pk PRIMARY KEY  (MinAttendancePercentageToPassStudiesID)
    );
    """
  insertions = []
  min_attendance_percentage_to_pass_studies_id = 1
  # for student_id in all_students.keys():
  #   studies_id = all_students[student_id]
  #   for internship_id, start_date, company_name in all_internships[studies_id]:
  #     end_date = start_date + timedelta(14)
  #     number_of_days = 14
  insertions.append(
      f"INSERT INTO DaysInInternship (StartDate, EndDate, NumberOfDays, InternshipID) VALUES ('2020-01-01', NULL, 14, NULL);"
  )
      # min_attendance_percentage_to_pass_studies_id += 1
  return insertions


def generate_exams_grades():
  '''
    CREATE TABLE ExamsGrades (
        StudentID int  NOT NULL,
        ExamID int  NOT NULL,
        FinalGrade decimal(2,1)  NOT NULL,
        CONSTRAINT FinalExams_FinalGradeIsValid CHECK (FinalGrade IN (2.0, 3.0, 3.5, 4.0, 4.5, 5.0)),
        CONSTRAINT ExamsGrades_pk PRIMARY KEY  (StudentID,ExamID)
    );
    '''
  insertions = []
  for student_id in all_students.keys():
    studies_id = all_students[student_id]
    subject_id = random.choice(all_subjects[studies_id])
    exam_id = all_exams[subject_id]
    final_grade = random.choice([2.0, 3.0, 3.5, 4.0, 4.5, 5.0])
    insertions.append(
        f"INSERT INTO ExamsGrades (StudentID, ExamID, FinalGrade) VALUES ('{student_id}', '{exam_id}', '{final_grade}');"
    )
  return insertions


def generate_min_attendance_percentage_to_pass_studies():
  '''
    CREATE TABLE MinAttendancePercentageToPassStudies (
        MinAttendancePercentageToPassStudiesID int  NOT NULL,
        StartDate datetime  NOT NULL,
        EndDate datetime  NULL,
        AttendancePercentage decimal(6,4)  NOT NULL,
        StudiesID int  NULL,
        CONSTRAINT MinAttendancePercentageToPassStudies_DateIntervalIsValid CHECK (StartDate < EndDate),
        CONSTRAINT MinAttendancePercentageToPassStudies_PercentageIsValid CHECK (AttendancePercentage BETWEEN 0 AND 1),
        CONSTRAINT MinAttendancePercentageToPassStudies_pk PRIMARY KEY  (MinAttendancePercentageToPassStudiesID)
    );
    '''
  insertions = []
  # for min_attendance_percentage_to_pass_studies_id, studies_id in enumerate(
  #     all_studies.keys()):
  #   field, start_date, end_date, max_students, price, language, semester = all_studies[
  #       studies_id]
  #   attendance_percentage = round(random.uniform(0.5, 1), 2)
  insertions.append(
      f"INSERT INTO MinAttendancePercentageToPassStudies (StartDate, EndDate, AttendancePercentage, StudiesID) VALUES ('2020-01-01', NULL, 0.8, NULL);"
  )
  return insertions


def generate_studies_sessions():
  '''
    CREATE TABLE StudiesSessions (
        StudiesSessionID int  NOT NULL,
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
    '''
  possible_hours = [(9, 30), (11, 20), (13, 0), (15, 30)]
  insertions = []
  session_id = 1
  for subject_id in reverse_subjects.keys():
    session_type = random.randint(1, 2)

    field, start_date, end_date, max_students, price, language_id, semester = all_studies[
        reverse_subjects[subject_id]]
    start_date += timedelta(random.randint(0, 7))
    hour = random.choice(possible_hours)
    start_date += timedelta(hours=hour[0], minutes=hour[1])

    lecturer_id = random.randint(9, 25)
    max_students = random.randint(20, 30)
    if language_id == 2:
      translator_id = random.randint(1, 4)
    elif language_id == 3:
      translator_id = random.randint(5, 8)
    else:
      translator_id = "NULL"

    while start_date < end_date:
      insertions.append("SET IDENTITY_INSERT StudiesSessions ON;")
      insertions.append(
          f"INSERT INTO StudiesSessions (StudiesSessionID, SubjectID, StartDate, EndDate, LecturerID, MaxStudents, TranslatorID, LanguageID) VALUES ({session_id}, {subject_id}, '{start_date.strftime('%Y-%m-%d %H:%M:%S')}', '{(start_date + timedelta(hours=1, minutes=30)).strftime('%Y-%m-%d %H:%M:%S')}', {lecturer_id}, {max_students}, {format_nullable(translator_id)}, {language_id});"
      )
      insertions.append("SET IDENTITY_INSERT StudiesSessions OFF;")
      all_sessions[subject_id] = all_sessions.get(subject_id,
                                                  []) + [session_id]

      if session_type == 1: online_sessions.add((session_id, language_id))
      elif session_type == 2: stationary_sessions.add(session_id)

      if random.randint(1, 10) <= 2:
        public_sessions.add(session_id)

      session_data[session_id] = {
          "subject_id": subject_id,
          "start_date": start_date,
          "end_date": start_date + timedelta(hours=1, minutes=30),
          "lecturer_id": lecturer_id,
          "max_students": max_students
      }

      start_date += timedelta(14)
      session_id += 1

  return insertions


def generate_stationary_studies_sessions():
  '''
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
    '''
  insertions = []
  country = "Poland"
  for stationary_studies_session_id in list(stationary_sessions):
    city = random.choice(cities)
    postal_code = f"{random.randint(10, 99)}-{random.randint(100, 999)}"
    address = random.choice(addresses) + " " + str(random.randint(3, 100))
    classrooom_number = f"{random.randint(1, 10)}.{random.randint(20, 29)}{random.choice(['a', 'b', 'c', 'd', 'e'])}"
    insertions.append(
        f"INSERT INTO StationaryStudiesSessions (StationaryStudiesSessionID, Address, City, Country, PostalCode, ClassroomNumber) VALUES ('{stationary_studies_session_id}', '{address}', '{city}', '{country}', '{postal_code}', '{classrooom_number}');"
    )
  return insertions


def generate_online_studies_sessions():
  '''
    CREATE TABLE OnlineStudiesSessions (
        OnlineStudiesSessionID int  NOT NULL,
        WebinarLink nvarchar(max)  NOT NULL,
        RecordingLink int  NULL,
        TranslatorID int  NULL,
        CONSTRAINT OnlineStudiesSessions_pk PRIMARY KEY  (OnlineStudiesSessionID)
    );
    '''
  insertions = []
  for online_studies_session_id, language_id in list(online_sessions):
    webinar_link = f'https://link{online_studies_session_id}.pl'
    recording_link = f'Rec link {online_studies_session_id}'

    insertions.append(
        f"INSERT INTO OnlineStudiesSessions (OnlineStudiesSessionID, WebinarLink, RecordingLink) VALUES ('{online_studies_session_id}', '{webinar_link}', '{recording_link}');"
    )
  return insertions


def generate_public_study_sessions():
  '''
  CREATE TABLE PublicStudySessions (
      PublicStudySessionID int  NOT NULL,
      StudiesSessionID int  NOT NULL,
      Description nvarchar(max)  NOT NULL,
      CONSTRAINT PublicStudySessions_ak_1 UNIQUE (StudiesSessionID),
      CONSTRAINT PublicStudySessions_pk PRIMARY KEY  (PublicStudySessionID)
  );
    '''
  insertions = []


  price = random.randint(100, 300)
  
  for public_study_session_id in list(public_sessions):
    data = session_data[public_study_session_id]
    start_date = data['start_date']
    closed_at = data['end_date']

    product_id = new_product_id()
    
    added_at = start_date - timedelta(days=14)
    if added_at > datetime.now():
      now = datetime.now()
      added_at = datetime(now.year, now.month, now.day, 0, 0, 0)

    if closed_at > datetime.now():
      closed_at = 'NULL'
    
    insertions.append("SET IDENTITY_INSERT Products ON;")
    insertions.append(
      f"INSERT INTO Products (ProductID, Price, AdvancePayment, ProductType, AddedAt, ClosedAt)VALUES ({product_id}, {price}, NULL, 'public study session', {format_nullable(added_at)}, {format_nullable(closed_at)}); "
    )
    
    insertions.append("SET IDENTITY_INSERT Products OFF;")

    description = f"Public study session description {product_id}"
    
    insertions.append(
        f"INSERT INTO PublicStudySessions (PublicStudySessionID, StudiesSessionID, Description) VALUES ({product_id}, {public_study_session_id}, '{description}');"
    )
    
    public_session_id[public_study_session_id] = product_id
  return insertions


def generate_studies_session_attendance():
  '''
    CREATE TABLE StudiesSessionsAttendence (
        SessionID int  NOT NULL,
        StudentID int  NOT NULL,
        Completed bit  NOT NULL,                           
        CONSTRAINT StudiesSessionsAttendence_pk PRIMARY KEY  (SessionID,StudentID)                     
    );                                                                                                                                                                                                                                                      
    '''
  insertions = []
  for student_id in all_students.keys():
    studies_id = all_students[student_id]
    subjects = all_subjects[studies_id]
    for subject_id in subjects:
      sessions = all_sessions[subject_id]
      for session_id in sessions:
        comlpeted = random.randint(0, 1)
        insertions.append(
            f"INSERT INTO StudiesSessionsAttendence (SessionID, StudentID, Completed) VALUES ('{session_id}', '{student_id}', '{comlpeted}');"
        )
  return insertions


def generate_made_up_attendance():
  '''
    CREATE TABLE MadeUpAttendance (
        MadeUpAttendanceID int  NOT NULL,
        SubjectID int  NOT NULL,
        ProductID int  NOT NULL,
        StudentID int  NOT NULL,
        CONSTRAINT MadeUpAttendance_ak_1 UNIQUE (SubjectID, ProductID, StudentID),
        CONSTRAINT MadeUpAttendance_pk PRIMARY KEY  (MadeUpAttendanceID)
    );
    '''
  insertions = []
  students = random.sample(list(all_students.keys()), 30)


  made_up_attendance_id = 1
  for student_id in students:
    subject_id = random.choice(all_subjects[all_students[student_id]])
    product_id = all_makeups[subject_id]
    
    insertions.append(
        f"INSERT INTO MadeUpAttendance VALUES ({subject_id}, {product_id}, {student_id});"
    )
    made_up_attendance_id += 1
  return insertions


def generate_public_study_sessions_participants():
  '''
    CREATE TABLE PublicStudySessionParticipants (
        PublicStudySessionParticipantID int  NOT NULL,
        UserID int  NOT NULL,
        PublicStudySessionID int  NOT NULL,
        SessionPrice money  NOT NULL,
        DuePostponedPayment datetime  NULL,
        FullPricePaymentID int  NULL,
        CONSTRAINT PublicStudySessionParticipants_SessionPriceIsValid CHECK (SessionPrice > 0),
        CONSTRAINT PublicStudySessionParticipants_pk PRIMARY KEY  (PublicStudySessionParticipantID)
    );
    '''
  insertions = []
  for public_study_session_participant_id in range(1, 201):
    user_id = random.randint(41, 300)
    public_study_session_id = random.choice(list(public_sessions))
    public_session_price[public_study_session_id] = public_session_price.get(
        public_study_session_id, round(random.uniform(100, 500), 2))
    session_price = public_session_price[public_study_session_id]
    due_postponed_payment = random.choice([
        "NULL",
        datetime(year=random.randint(2021, 2025),
                 month=random.randint(1, 12),
                 day=random.randint(1, 28)).strftime('%Y-%m-%d %H:%M:%S'),
        datetime(year=random.randint(2021, 2025),
                 month=random.randint(1, 12),
                 day=random.randint(1, 28)).strftime('%Y-%m-%d %H:%M:%S'),
        datetime(year=random.randint(2021, 2025),
                 month=random.randint(1, 12),
                 day=random.randint(1, 28)).strftime('%Y-%m-%d %H:%M:%S')
    ])

    product_id = public_session_id[public_study_session_id]
    if due_postponed_payment == "NULL":
      full_price_payment_id = "NULL"
    else:
      full_price_payment_id = new_payment_id()

      data = session_data[public_study_session_id] 
      payment_date = data['start_date'] - timedelta(days=random.randint(3, 8))

      if payment_date > datetime.now():
        now = datetime.now()
        payment_date = datetime(now.year, now.month, now.day, 0, 0, 0) - timedelta(hours=random.randint(1,24))
      
      insertions.append("SET IDENTITY_INSERT Payments ON;")  
      insertions.append(
        f"INSERT INTO Payments (PaymentID, UserID, ProductID, Price, Date, Status) VALUES ({full_price_payment_id}, {user_id}, {product_id}, {session_price}, " \
        f"'{payment_date}', 'successful');"
      )
      insertions.append("SET IDENTITY_INSERT Payments OFF;")  


    insertions.append("SET IDENTITY_INSERT PublicStudySessionParticipants ON;")
    insertions.append(
        f"INSERT INTO PublicStudySessionParticipants (PublicStudySessionParticipantID, UserID, PublicStudySessionID, SessionPrice, DuePostponedPayment, FullPricePaymentID)  VALUES ('{public_study_session_participant_id}', '{user_id}', '{product_id}', '{session_price}', {format_nullable(due_postponed_payment)}, {format_nullable(full_price_payment_id)});"
    )
    insertions.append("SET IDENTITY_INSERT PublicStudySessionParticipants OFF;")
    public_session_participants[
        public_study_session_participant_id] = public_study_session_id
  return insertions


def generate_public_study_sessions_attendance_for_outsiders():
  '''
    CREATE TABLE PublicStudySessionsAttendanceForOutsiders (
        PublicStudySessionID int  NOT NULL,
        Completed bit  NOT NULL,
        PublicStudySessionParticipantID int  NOT NULL,
        CONSTRAINT PublicStudySessionsAttendanceForOutsiders_pk PRIMARY KEY  (PublicStudySessionID)
    );
    '''
  insertions = []
  for public_study_session_participant_id in public_session_participants.keys(
  ):
    public_study_session_id = public_session_participants[
        public_study_session_participant_id]
    # wydaje mi się że tu też jest duplikacja danych z tym productID
    product_id = public_session_id[public_study_session_id]
    completed = random.randint(0, 1)
    insertions.append(
        f"INSERT INTO PublicStudySessionsAttendanceForOutsiders (PublicStudySessionID, Completed, PublicStudySessionParticipantID) VALUES ('{product_id}', '{completed}', '{public_study_session_participant_id}');"
    )
  return insertions


def generate_max_days_for_payment_before_studies_start():
  '''
    CREATE TABLE MaxDaysForPaymentBeforeStudiesStart (
        MaxDaysForPaymentBeforeStudiesStartID int  NOT NULL,
        StartDate datetime  NOT NULL,
        EndDate datetime  NULL,
        NumberOfDays int  NOT NULL,
        StudiesID int  NOT NULL,
        CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_DateIntervalIsValid CHECK (EndDate > StartDate),
        CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_NumberOfDaysIsValid CHECK (NumberOfDays > 0),
        CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_pk PRIMARY KEY  (MaxDaysForPaymentBeforeStudiesStartID)
    );
    '''
  insertions = []
  for studies_id in list(all_studies.keys())[:5]:
    field_id, start_date, end, max_students, price, language, semester = all_studies[
        studies_id]
    max_days_before_payment_id = studies_id
    end_date = start_date - timedelta(3)
    modifier = random.randint(10, 30)
    start_date = end_date - timedelta(modifier)
    number_of_days = modifier
    insertions.append(
        f"INSERT INTO MaxDaysForPaymentBeforeStudiesStart (StartDate, EndDate, NumberOfDays, StudiesID) VALUES ('{start_date.strftime('%Y-%m-%d %H:%M:%S')}', '{end_date.strftime('%Y-%m-%d %H:%M:%S')}', '{number_of_days}', '{studies_id}');"
    )
  insertions.append(
        f"INSERT INTO MaxDaysForPaymentBeforeStudiesStart (StartDate, EndDate, NumberOfDays, StudiesID) VALUES ('2020-01-01', NULL, 3, NULL);"
  )
  return insertions


#-----------------------------

all_insertions = [
  generate_fields_of_study(),
  generate_studies(),
  generate_subjects(),
  generate_subject_make_up_possibilities(),
  generate_exams(),
  generate_internships(),
  generate_students(),
  generate_internship_details(),
  generate_min_attendance_percentage_to_pass_internship(),
  generate_days_in_internship(),
  generate_exams_grades(),
  generate_min_attendance_percentage_to_pass_studies(),
  generate_studies_sessions(),
  generate_stationary_studies_sessions(),
  generate_online_studies_sessions(),
  generate_public_study_sessions(),
  generate_studies_session_attendance(),
  generate_made_up_attendance(),
  generate_public_study_sessions_participants(),
  generate_public_study_sessions_attendance_for_outsiders(),
  generate_max_days_for_payment_before_studies_start()
]

all_insertions = ['\n'.join(i) for i in all_insertions]

text = '\n'.join(all_insertions)



print(f"""
BEGIN TRANSACTION;

BEGIN TRY
   {text} 
    COMMIT;
END TRY
BEGIN CATCH
    -- If an error occurs, rollback the transaction
    ROLLBACK;
    SELECT 
    ERROR_MESSAGE() AS ErrorMessage, 
    ERROR_LINE() AS ErrorLine;
END CATCH;

""")