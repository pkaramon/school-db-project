import random
from datetime import datetime, timedelta
from contextlib import redirect_stdout
from math import floor
import string

random.seed(42)  # VERY IMPORTANT

participant_id = 0


def new_course_participant_id():
  global participant_id
  participant_id += 1
  return participant_id


def generate_people():
  # CREATE TABLE People (
  #     PersonID int  NOT NULL,
  #     FirstName nvarchar(max)  NOT NULL,
  #     LastName nvarchar(500)  NOT NULL,
  #     BirthDate date  NOT NULL,
  #     Address nvarchar(500)  NOT NULL,
  #     City nvarchar(500)  NOT NULL,
  #     Region nvarchar(500)  NOT NULL,
  #     PostalCode nvarchar(20)  NOT NULL,
  #     Country nvarchar(500)  NOT NULL,
  #     Phone nvarchar(20)  NOT NULL,
  #     Email nvarchar(500)  NOT NULL,
  #     CONSTRAINT People_EmailValid CHECK (Email LIKE '%@%'),
  #     CONSTRAINT People_BirthDateValid CHECK (BirthDate <= GetDate()),
  #     CONSTRAINT People_PhoneIsValid CHECK ((ISNUMERIC([Phone])=(1))),
  #     CONSTRAINT People_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
  #     CONSTRAINT Person_pk PRIMARY KEY  (PersonID)
  # );
  #
  first_names = [
      "Adam", "Anna", "Piotr", "Katarzyna", "Tomasz", "Magdalena", "Michał",
      "Agnieszka", "Jakub", "Natalia", "Marek", "Ewa", "Karol", "Joanna",
      "Rafał", "Paulina", "Łukasz", "Monika", "Michał", "Justyna", "Krzysztof",
      "Izabela", "Maciej", "Kinga", "Szymon"
  ]
  last_names = [
      "Nowak", "Wójcik", "Kowalczyk", "Kamiński", "Lewandowski", "Dąbrowski",
      "Zieliński", "Szymański", "Woźniak", "Łuczak", "Kalinowski",
      "Kaźmierczak", "Mazurek", "Makowski", "Rutkowski", "Sobolewski",
      "Sawicki", "Olczak", "Krawczyk", "Sobczak", "Czarnecki", "Bartosz",
      "Pająk", "Kubiak"
  ]
  cities = [
      "Warsaw", "Krakow", "Gdansk", "Wroclaw", "Poznan", "Szczecin", "Lublin",
      "Katowice", "Bialystok", "Gdynia"
  ]
  streets = [
      "Aleja Jana Pawła II", "ul. Nowy Świat", "ul. Marszałkowska",
      "ul. Krakowska", "ul. Wojska Polskiego", "ul. Piłsudskiego",
      "ul. Mickiewicza", "ul. Słowackiego"
  ]

  insert_statements = []
  for i in range(300):
    first_name = random.choice(first_names)
    last_name = random.choice(last_names)
    email = f"{first_name.lower()}.{last_name.lower()}{i+1}@example.com"
    city = random.choice(cities)
    postal_code = f"{random.randint(10, 99)}-{random.randint(100, 999)}"
    phone = f"{random.randint(100, 999)}{random.randint(100, 999)}{random.randint(100, 999)}"
    street = random.choice(streets)
    if i < 40:
      birth_date = datetime.now() - timedelta(
          days=random.randint(35 * 365, 62 * 365))
    else:
      birth_date = datetime.now() - timedelta(
          days=random.randint(18 * 365, 33 * 365))

    insert_statements.append("SET IDENTITY_INSERT People ON;")
    insert_statements.append(
        f"INSERT INTO People (PersonID, FirstName, LastName, BirthDate, Address, City, Region, PostalCode, Country, Phone, Email) VALUES ({i+1}, '{first_name}', '{last_name}', '{birth_date.strftime('%Y-%m-%d')}', '{street}', '{city}', 'Poland', '{postal_code}', 'Poland', '{phone}', '{email}');"
    )
    insert_statements.append("SET IDENTITY_INSERT People OFF;")

  return insert_statements


def generate_employees():
  # CREATE TABLE Employees (
  #     EmployeeID int  NOT NULL,
  #     CONSTRAINT id PRIMARY KEY  (EmployeeID)
  # );
  employee_statements = []
  for i in range(40):
    hire_date = datetime.now() - timedelta(days=random.randint(30, 5 * 365))
    employee_id = i + 1
    is_active = 1
    employee_statements.append(
        f"INSERT INTO Employees (EmployeeID, HireDate, IsActive) VALUES ({employee_id}, '{hire_date.strftime('%Y-%m-%d')}', {is_active});"
    )
  return employee_statements


def generate_roles():
  #-- Table: Roles
  #CREATE TABLE Roles (
  #    RoleID int  NOT NULL IDENTITY,
  #    RoleName nvarchar(200)  NOT NULL,
  #    CONSTRAINT RoleName UNIQUE (RoleName),
  #    CONSTRAINT employeeType PRIMARY KEY  (RoleID)
  #);
  role_statements = [
    'SET IDENTITY_INSERT Roles ON;',
    "INSERT INTO Roles (RoleID, RoleName) VALUES (1, 'Administrator');",
    "INSERT INTO Roles (RoleID, RoleName) VALUES (2, 'HeadMaster');",
    "INSERT INTO Roles (RoleID, RoleName) VALUES (3, 'English Translator');",
    "INSERT INTO Roles (RoleID, RoleName) VALUES (4, 'Academic Teacher');",
    "INSERT INTO Roles (RoleID, RoleName) VALUES (5, 'Course Teacher');",
    "INSERT INTO Roles (RoleID, RoleName) VALUES (6, 'Accountant');",
    "INSERT INTO Roles (RoleID, RoleName) VALUES (7, 'WebinarLecturer');",
    "INSERT INTO Roles (RoleID, RoleName) VALUES (8, 'Secretariat');",
    'SET IDENTITY_INSERT Roles OFF;',
  ]
  return role_statements


def generate_employee_roles():
  # CREATE TABLE EmployeeRoles (
  #     EmployeeRoleEntryID int  NOT NULL IDENTITY,
  #     EmployeeID int  NOT NULL,
  #     RoleID int  NOT NULL,
  #     CONSTRAINT EmployeeRoles_ak_1 UNIQUE (EmployeeRoleEntryID, RoleID),
  #     CONSTRAINT EmployeeRoles_pk PRIMARY KEY  (EmployeeRoleEntryID)
  # );
  statements = []
  for i in range(1,5):
    statements.append(f"INSERT INTO EmployeeRoles(EmployeeID, RoleID) VALUES ({i}, 1);")
  for i in range(9, 36):
    for j in (4,5,7):
      statements.append(f"INSERT INTO EmployeeRoles(EmployeeID, RoleID) VALUES ({i},{j});")
  statements.append("INSERT INTO EmployeeRoles(EmployeeID, RoleID) VALUES (36, 8);")
  statements.append("INSERT INTO EmployeeRoles(EmployeeID, RoleID) VALUES (37, 1);")
  statements.append("INSERT INTO EmployeeRoles(EmployeeID, RoleID) VALUES (38, 2);")
  statements.append("INSERT INTO EmployeeRoles(EmployeeID, RoleID) VALUES (39, 6);")
  return statements

    
  

def generate_languages():
  # CREATE TABLE Languages (
  #     LanguageID int  NOT NULL,
  #     LanguageName nvarchar(200)  NOT NULL,
  #     CONSTRAINT LanguageName UNIQUE (LanguageName),
  #     CONSTRAINT Languages_pk PRIMARY KEY  (LanguageID)
  # );
  languages = ['Polish', 'English', 'Spanish']
  language_statements = []
  for i in range(len(languages)):
    
    language_statements.append("SET IDENTITY_INSERT Languages ON;")
    language_statements.append(
        f"INSERT INTO Languages(LanguageID, LanguageName) VALUES ({i + 1}, '{languages[i]}');")
    language_statements.append("SET IDENTITY_INSERT Languages OFF;")
  return language_statements


def generate_users():
  # -- Table: Users
  # CREATE TABLE Users (
  #     UserID int  NOT NULL,
  #     CONSTRAINT Users_pk PRIMARY KEY  (UserID)
  # );
  user_statements = []
  for i in range(41, 300):
    user_id = i + 1
    user_statements.append(f"INSERT INTO Users (UserID) VALUES ({user_id});")
  return user_statements


def generate_payments(courses, course_id, course_table):
  '''
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

CREATE TABLE CourseParticipants (
    CourseParticipantID int  NOT NULL,
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

    '''
  for key in course_table:
    course_table[key]["participants"] = []
    course_table[key]["users"] = []

  num_of_courses = 16
  payed_full = 0

  for i in range(100):
    if payed_full:
      payed_full = 0
      continue
    payment_id = i + 101
    c_id = random.choice(course_id)
    user_id = random.randint(42, 300)
    time_delta = course_table[c_id]["end_date"] - course_table[c_id][
        "start_date"]
    random_days = random.randint(0, time_delta.days - 1)
    date = course_table[c_id]["added_at"] + timedelta(days=random_days)

    if user_id in course_table[c_id]["users"]:
      continue

    # if user_id in course_table[c_id]["participants"]:
    #   continue

    advance_or_full = random.random() < .7
    payment_price = course_table[c_id][
        "price"] if advance_or_full else course_table[c_id]["advance_payment"]
    status_accept = random.random() < .9
    status = "Successful" if status_accept else "Failed"
    
    courses.append("SET IDENTITY_INSERT Payments ON;")
    courses.append(
        f"INSERT INTO Payments (PaymentID, UserID, ProductID, Price, Date, Status) VALUES ({payment_id}, {user_id}, {c_id}, {payment_price}, '{date.strftime('%Y-%m-%d %H:%M:%S')}', '{status}');"
    )
    courses.append("SET IDENTITY_INSERT Payments OFF;")
    if not advance_or_full and i < 99 and status_accept:
      payed_full = 1 if random.random() < .1 else 0
    if payed_full:
      courses.append("SET IDENTITY_INSERT Payments ON;")
      courses.append(
          f"INSERT INTO Payments (PaymentID, UserID, ProductID, Price, Date, Status) VALUES ({payment_id + 1}, {user_id}, {c_id}, {course_table[c_id]['price'] - payment_price}, '{date.strftime('%Y-%m-%d %H:%M:%S')}', '{status}');"
      )
      courses.append("SET IDENTITY_INSERT Payments OFF;")

    if status_accept:
      postponed = 1 if random.random() < 0.05 else 0
      postponed_due = "NULL" if postponed == 0 else "'" + (
          course_table[c_id]["start_date"] + timedelta(
              days=random.randint(1, 20))).strftime('%Y-%m-%d %H:%M:%S') + "'"
      participant_id = new_course_participant_id()
      if advance_or_full:
        
        courses.append("SET IDENTITY_INSERT CourseParticipants ON;")
        courses.append(
            f"INSERT INTO CourseParticipants (CourseParticipantID, UserID, CourseID, CoursePrice, EntryFee, EntryFeePaymentID, RemainingPaymentID, FullPricePaymentID, DuePostponedPayment, AddedAt, Completed) VALUES ({participant_id}, {user_id}, {c_id}, {course_table[c_id]['price']} , {course_table[c_id]['advance_payment'] }, NULL, NULL, {payment_id}, {postponed_due}, '{date.strftime('%Y-%m-%d %H:%M:%S')}', 0);"
        )
        courses.append("SET IDENTITY_INSERT CourseParticipants OFF;")
      else:
        
        
        if payed_full:
          courses.append("SET IDENTITY_INSERT CourseParticipants ON;")
          courses.append(
              f"INSERT INTO CourseParticipants (CourseParticipantID, UserID, CourseID, CoursePrice, EntryFee, EntryFeePaymentID, RemainingPaymentID, FullPricePaymentID, DuePostponedPayment, AddedAt, Completed) VALUES ({participant_id}, {user_id}, {c_id}, {course_table[c_id]['price'] }, {course_table[c_id]['advance_payment']}, {payment_id},  {payment_id + 1}, NULL, {postponed_due}, '{date.strftime('%Y-%m-%d %H:%M:%S')}', 0);"
          )
          courses.append("SET IDENTITY_INSERT CourseParticipants OFF;")
        else:
          courses.append("SET IDENTITY_INSERT CourseParticipants ON;")
          courses.append(
              f"INSERT INTO CourseParticipants (CourseParticipantID, UserID, CourseID, CoursePrice, EntryFee, EntryFeePaymentID, RemainingPaymentID, FullPricePaymentID, DuePostponedPayment, AddedAt, Completed) VALUES ({participant_id}, {user_id}, {c_id}, {course_table[c_id]['price'] }, {course_table[c_id]['advance_payment']}, {payment_id},  NULL, NULL, {postponed_due}, '{date.strftime('%Y-%m-%d %H:%M:%S')}', 0);"
          )
          courses.append("SET IDENTITY_INSERT CourseParticipants OFF;")
        
      course_table[c_id]["participants"].append(participant_id)
      
      course_table[c_id]["users"].append(user_id)

  return


def generate_modules(courses, course_table):
  '''
  CREATE TABLE Modules (
    ModuleID int  NOT NULL,
    CourseID int  NOT NULL,
    ModuleName nvarchar(max)  NOT NULL,
    ModuleDescription nvarchar(max)  NOT NULL,
    CONSTRAINT Modules_pk PRIMARY KEY  (ModuleID)
);
  '''

  module_id = 1
  for key in course_table:
    number_of_modules = len(course_table[key]["modules"])
    for current_module in range(number_of_modules):
      
      courses.append("SET IDENTITY_INSERT Modules ON;")
      courses.append(
          f"INSERT INTO Modules (ModuleID, CourseID, ModuleName, ModuleDescription) VALUES ({module_id}, {key}, '{course_table[key]['modules'][current_module]['name']}', '{course_table[key]['modules'][current_module]['desc']}');"
      )
      courses.append("SET IDENTITY_INSERT Modules OFF;")
      course_table[key]["modules"][current_module]["id"] = module_id
      module_id += 1
  return


def generate_random_link(length=10):
  characters = string.ascii_letters + string.digits + "-_"
  random_link = ''.join(random.choice(characters) for _ in range(length))
  return f"https://example.com/{random_link}"


def generate_sessions(courses, course_table):
  '''
  CREATE TABLE CoursesSessions (
    CourseSessionID int  NOT NULL,
    LanguageID int  NOT NULL,
    ModuleID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NULL,
    CONSTRAINT CoursesSessions_pk PRIMARY KEY  (CourseSessionID)
);
CREATE TABLE CourseOfflineSessions (
    CourseOfflineSessionID int  NOT NULL,
    Link nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    UploadedAt datetime  NOT NULL,
    CONSTRAINT CourseOfflineSessions_UploadedAtIsValid CHECK (UploadedAt <= GETDATE() ),
    CONSTRAINT CourseOfflineSessions_pk PRIMARY KEY  (CourseOfflineSessionID)
);
CREATE TABLE CourseOnlineSessions (
    CourseOnlineSessionID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    WebinarLink nvarchar(max)  NOT NULL,
    RecordingLink nvarchar(max)  NULL,
    CONSTRAINT CourseOnlineSessions_DateIntervalCheck CHECK (StartDate < EndDate),
    CONSTRAINT CourseOnlineSessions_pk PRIMARY KEY  (CourseOnlineSessionID)
);

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

'''
  session_id = 1
  session_types = ["offline", "stationary", "online"]
  num_of_session_in_module = 2
  for key in course_table:
    number_of_modules = len(course_table[key]["modules"])
    for current_module in range(number_of_modules):
      course_table[key]["modules"][current_module]["sessions"] = []
      for num_of_session in range(num_of_session_in_module):
        lecturer_id = random.randint(9, 35)
        language_id = random.randint(1, 3)
        if language_id != 1: 
          translator_id = random.randint(1, 4) if language_id == 2 else random.randint(5, 8)
        else:
          translator_id = "NULL"

        
        courses.append("SET IDENTITY_INSERT CoursesSessions ON;")
        courses.append(
            f"INSERT INTO CoursesSessions (CourseSessionID, LanguageID, ModuleID, LecturerID, TranslatorID) VALUES ({session_id}, {language_id}, {course_table[key]['modules'][current_module]['id']}, {lecturer_id}, {translator_id});"
        )
        courses.append("SET IDENTITY_INSERT CoursesSessions OFF;")

        
        course_added_at = course_table[key]["added_at"]
        session_type = random.choice(session_types)
        link1 = generate_random_link()
        link2 = generate_random_link() if random.random() < 0.8 else "NULL"
        time_delta = course_table[key]["end_date"] - course_table[key][
            "start_date"]
        start_d = course_table[key]["start_date"] + timedelta(
            days=(time_delta.days //
                  (num_of_session_in_module + 1)) * num_of_session)
        end_d = start_d + timedelta(minutes=90)
        course_table[key]["modules"][current_module]["sessions"].append(
            session_id)
        if session_type == "offline":
          desc = "Example description for session number: " + str(
              num_of_session + 1) + " in module " + str(
                  current_module +
                  1) + " in course " + course_table[key]["name"] + "."
          courses.append(
              f"INSERT INTO CourseOfflineSessions (CourseOfflineSessionID, Link, Description, UploadedAt) VALUES ({session_id}, '{link1}', '{desc}', '{format_datetime(course_added_at)}' );"
          )
        elif session_type == "stationary":
          polish_cities = [
              "Warszawa", "Kraków", "Łódź", "Wrocław", "Poznań", "Gdańsk",
              "Szczecin", "Bydgoszcz", "Lublin", "Białystok"
          ]
          adress = [
              "ul. Strzegowska 105", "ul. Widawska 58", "ul. Młynarska 136",
              "ul. Drogowa 98"
          ]

          postal_code = f"{random.randint(10, 99)}-{random.randint(100, 999)}"
          clasroom_number = str(random.randint(10, 30)) + random.choice(
              ['a', 'b', 'c', 'd', 'e'])

          if course_table[key]["max_students"] != "NULL":
            max_students = random.randint(
                int(course_table[key]["max_students"]), 40)
          else:
            max_students = random.randint(20, 40)

          courses.append(
              f"INSERT INTO CourseStationarySessions (CourseStationarySessionID, StartDate, EndDate,  Address, City, Country, PostalCode, ClassroomNumber, MaxStudents) VALUES ({session_id}, '{format_datetime(start_d)}', '{format_datetime(end_d)}', '{random.choice(adress)}', '{random.choice(polish_cities)}', 'Poland', '{postal_code}', '{clasroom_number}', {max_students});"
          )
        else:
          courses.append(
              f"INSERT INTO CourseOnlineSessions (CourseOnlineSessionID, StartDate, EndDate, WebinarLink, RecordingLink) VALUES ({session_id}, '{format_datetime(start_d)}', '{format_datetime(end_d)}', '{link1}', '{link2}');"
          )
        session_id += 1

  return


def format_datetime(dt):
  return dt.strftime('%Y-%m-%d %H:%M:%S')


def generate_attendance(courses, course_table):
  '''
    CREATE TABLE CourseSessionsAttendance (
    CourseParticipantID int  NOT NULL,
    CourseSessionID int  NOT NULL,
    Completed bit  NOT NULL,
    CONSTRAINT CourseSessionsAttendance_pk PRIMARY KEY  (CourseSessionID,CourseParticipantID)
);  '''
  for key in course_table:
    number_of_modules = len(course_table[key]["modules"])
    for current_module in range(number_of_modules):
      for session_id in course_table[key]["modules"][current_module][
          "sessions"]:
        for particpant_id in course_table[key]["participants"]:
          completed = 1 if random.random() < 0.9 else 0
          courses.append(
              f"INSERT INTO CourseSessionsAttendance (CourseParticipantID, CourseSessionID, Completed) VALUES ({particpant_id}, {session_id}, {completed});"
          )

  return


def generate_rules(courses, course_table):
  '''
  CREATE TABLE MinAttendancePercentageToPassCourse (
    MinAttendancePercentageToPassCourseID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    AttendancePercentage decimal(6,4)  NOT NULL,
    CourseID int  NULL,
    CONSTRAINT MinAttendancePercentageToPassCourse_DateIntervalIsValid CHECK ((StartDate < EndDate)),
    CONSTRAINT MinAttendancePercentageToPassCourse_AttendencePercentageIsValid CHECK ((AttendancePercentage >= 0) and (AttendancePercentage <= 1)),
    CONSTRAINT MinAttendancePercentageToPassCourse_pk PRIMARY KEY  (MinAttendancePercentageToPassStudiesID)
);

CREATE TABLE MaxDaysForPaymentBeforeCourseStart (
    MaxDaysForPaymentBeforeCourseStartID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    CourseID int  NULL,
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_NumberOfDaysIValid CHECK (NumberOfDays > 0),
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_pk PRIMARY KEY  (MaxDaysForPaymentBeforeCourseStartID)
);
  '''
  s_date = datetime.now() - timedelta(days=365)
  courses.append(
      f"INSERT INTO MinAttendancePercentageToPassCourse ( StartDate, EndDate, AttendancePercentage) VALUES ('{format_datetime(s_date)}', NULL, 0.80);"
  )
  courses.append(
      f"INSERT INTO MaxDaysForPaymentBeforeCourseStart (StartDate, EndDate, NumberOfDays) VALUES ( '{format_datetime(s_date)}', NULL, 3);"
  )
  # attend_id = 2
  # for i in range(5):
  #   s_date = datetime.now() - timedelta(days=random.randint(60, 400))
  #   e_date = datetime.now() - timedelta(days=random.randint(5, 50))
  #   in_course1 = "NULL" if random.random() < 0.7 else "'" + str(
  #       random.randint(20, 40)) + "'"
  #   in_course2 = "NULL" if random.random() < 0.7 else "'" + str(
  #       random.randint(20, 40)) + "'"
  #   num_of_days = random.randint(1, 40)
  #   courses.append(
  #       f"INSERT INTO MinAttendancePercentageToPassCourse (MinAttendancePercentageToPassStudiesID, StartDate, EndDate, AttendancePercentage, CourseID) VALUES ({attend_id}, '{format_datetime(s_date)}', '{format_datetime(e_date)}',0.8,  {in_course1});"
  #   )
  #   courses.append(
  #       f"INSERT INTO MaxDaysForPaymentBeforeCourseStart (MaxDaysForPaymentBeforeCourseStartID, StartDate, EndDate, NumberOfDays, CourseID) VALUES ({attend_id}, '{format_datetime(s_date)}', '{format_datetime(e_date)}',  {num_of_days}, {in_course2});"
  #   )
  #   attend_id += 1
  return


def generate_courses():
  '''
  CREATE TABLE Products (
    ProductID int  NOT NULL,
    Price money  NOT NULL,
    AdvancePayment money  NULL,
    ProductType nvarchar(max)  NOT NULL,
    AddedAt datetime  NOT NULL,
    ClosedAt datetime NULL,
    CONSTRAINT Products_PriceIsValid CHECK (Price >= 0),
    CONSTRAINT Products_AdvancePaymentIsValid CHECK ((AdvancePayment > 0 AND AdvancePayment < Price) OR (AdvancePayment IS NULL)),
    CONSTRAINT Products_ProductTypeIsValid CHECK (ProductType IN ('studies', 'course','webinar', 'public study session')),
    CONSTRAINT Products_AddedAtIsValid CHECK (AddedAt <= GetDate()),
    CONSTRAINT Products_ClosedAtIsValid CHECK (ClosedAt <= GetDate() AND ClosedAt >= AddedAt),
    CONSTRAINT Products_pk PRIMARY KEY  (ProductID)
);

  '''
  # CREATE TABLE Courses (
  #     CourseID int  NOT NULL,
  #     CourseName nvarchar(max)  NOT NULL,
  #     Description nvarchar(max)  NOT NULL,
  #     StartDate datetime  NOT NULL,
  #     EndDate datetime  NOT NULL,
  #     CoordinatorID int  NOT NULL,
  #     MaxStudents int  NULL,
  #     CONSTRAINT Course_MaxStudents CHECK (MaxStudents is NULL OR (MaxStudents > 0) ),
  #     CONSTRAINT Course_DateIntervalIsValid CHECK (StartDate < EndDate),
  #     CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
  # );
  course_names = [
      "Python dla początkujących", "Analiza danych w Pandas",
      "Programowanie w języku Java",
      "Tworzenie stron internetowych z HTML i CSS",
      "Sztuczna inteligencja w praktyce",
      "Rozwijanie umiejętności komunikacyjnych", "Machine Learning od podstaw",
      "Projektowanie interfejsów użytkownika", "Informatyka kwantowa",
      "Etyka w programowaniu", "Zaawansowane techniki programowania w C++",
      "Data Science: Wprowadzenie",
      "Tworzenie aplikacji mobilnych z React Native", "Analiza danych w R",
      "Bezpieczeństwo cybernetyczne", "Robotyka: Podstawy i zastosowania",
      "Projektowanie baz danych", "Grafika komputerowa",
      "Podstawy sztucznej inteligencji", "Internet rzeczy (IoT)",
      "Tworzenie gier komputerowych", "Big Data: Wprowadzenie",
      "Testowanie oprogramowania", "Blockchain: Technologia i zastosowania",
      "Cloud Computing: Wprowadzenie", "Programowanie funkcyjne w Haskell",
      "Systemy operacyjne", "Kurs języka SQL", "Analiza biznesowa",
      "Podstawy algorytmiki", "Projektowanie systemów informatycznych",
      "Wprowadzenie do sztucznej inteligencji", "Komunikacja interpersonalna",
      "Automatyzacja procesów biznesowych",
      "Języki skryptowe: Python, JavaScript",
      "Podstawy programowania obiektowego", "Algebra liniowa",
      "Analiza matematyczna", "Geometria analityczna", "Fizyka klasyczna",
      "Teoria chaosu", "Równania różniczkowe", "Mechanika kwantowa",
      "Statystyka matematyczna", "Teoria informacji", "Fizyka jądrowa",
      "Teoria układów dynamicznych"
  ]
  descriptions = [
      "Kurs przeznaczony dla osób, które dopiero zaczynają przygodę z programowaniem w języku Python.",
      "Zaawansowany kurs dotyczący analizy danych przy użyciu biblioteki Pandas w języku Python.",
      "Nauka programowania w języku Java, obejmująca podstawy i zaawansowane tematy.",
      "Tworzenie responsywnych stron internetowych z wykorzystaniem HTML i CSS.",
      "Praktyczne zastosowanie technologii sztucznej inteligencji w różnych dziedzinach.",
      "Rozwijanie umiejętności komunikacyjnych w kontekście pracy zespołowej.",
      "Podstawy i zaawansowane techniki machine learningu w praktyce.",
      "Projektowanie efektywnych interfejsów użytkownika w projektach IT.",
      "Wprowadzenie do podstaw informatyki kwantowej i zasady jej działania.",
      "Omówienie etycznych kwestii związanych z programowaniem i technologią.",
      "Zaawansowane zagadnienia programowania w języku C++.",
      "Wprowadzenie do analizy danych i statystyki w kontekście Data Science.",
      "Tworzenie mobilnych aplikacji przy użyciu frameworka React Native.",
      "Analiza danych w języku R w kontekście statystyki i analizy eksploracyjnej.",
      "Podstawy bezpieczeństwa cybernetycznego i ochrony przed atakami.",
      "Zasady działania robotów oraz ich zastosowania w różnych dziedzinach.",
      "Projektowanie i implementacja baz danych w praktyce.",
      "Tworzenie grafiki komputerowej przy użyciu różnych narzędzi i technik.",
      "Wprowadzenie do podstaw sztucznej inteligencji i jej zastosowań.",
      "Internet rzeczy i jego rola w interakcji między urządzeniami.",
      "Tworzenie gier komputerowych od podstaw.",
      "Wprowadzenie do zagadnień związanych z przetwarzaniem dużych zbiorów danych.",
      "Testowanie oprogramowania w praktyce.",
      "Technologia blockchain i jej zastosowania w różnych dziedzinach.",
      "Wprowadzenie do chmury obliczeniowej i usług cloud computing.",
      "Programowanie funkcyjne w języku Haskell.",
      "Podstawy systemów operacyjnych i zarządzania zasobami komputera.",
      "Nauka języka SQL w kontekście zarządzania bazami danych.",
      "Analiza biznesowa i tworzenie efektywnych strategii IT.",
      "Podstawy algorytmiki i rozwiązywanie problemów obliczeniowych.",
      "Projektowanie systemów informatycznych w oparciu o najlepsze praktyki.",
      "Wprowadzenie do sztucznej inteligencji i jej zastosowań w różnych dziedzinach.",
      "Rozwijanie umiejętności komunikacyjnych w relacjach interpersonalnych.",
      "Automatyzacja procesów biznesowych i optymalizacja działań organizacji.",
      "Nauka języków skryptowych: Python, JavaScript.",
      "Podstawy programowania obiektowego i projektowanie klas i obiektów.",
      "Podstawy algebraiczne i teoria układów równań liniowych.",
      "Analiza matematyczna funkcji i równań różniczkowych.",
      "Geometria analityczna i jej zastosowania w matematyce i fizyce.",
      "Podstawy fizyki klasycznej i prawa ruchu ciał.",
      "Zasady teorii chaosu i ich zastosowanie w naukach przyrodniczych.",
      "Równania różniczkowe i ich rola w modelowaniu zjawisk dynamicznych.",
      "Podstawy mechaniki kwantowej i zasady ruchu subatomowego.",
      "Statystyka matematyczna i analiza danych statystycznych.",
      "Teoria informacji i jej zastosowanie w przetwarzaniu sygnałów.",
      "Podstawy fizyki jądrowej i struktura jądra atomowego.",
      "Teoria układów dynamicznych i ich zachowanie w czasie."
  ]
  prices_cents = [0, 0.25, 0.50, 0.75]
  prices = []
  added_dates = []
  courses = []
  indices = []
  advance_payments = []
  start_dates = []
  course_table = {}
  for i in range(35):
    start_date = datetime.now() - timedelta(days=random.randint(-50, 50))
    end_date = start_date + timedelta(days=random.randint(1, 5))
    max_students = "NULL" if i in [2, 4, 9] else str(random.randint(10, 30))
    coordinator_id = random.randint(9, 35)
    course_id = i + 16
    added_at = start_date - timedelta(days=random.randint(70, 200))
    price = float(
        "{:.2f}".format(random.randint(30, 500) + random.choice(prices_cents)))
    advance_payment = random.randint(1, floor(price // 3))
    closed = 1 if start_date < datetime.now() else 0
    close_date = "NULL" if closed == 0 else f"'{format_datetime(start_date)}'"
    courses.append("SET IDENTITY_INSERT Products ON;")
    courses.append(
        f"INSERT INTO Products (ProductID, Price, AdvancePayment, ProductType, AddedAt,  ClosedAt) VALUES ({course_id}, {price}, {advance_payment}, 'course', '{added_at.strftime('%Y-%m-%d %H:%M:%S')}', {close_date});"
    )
    courses.append("SET IDENTITY_INSERT Products OFF;")
    courses.append(
        f"INSERT INTO Courses (CourseID, CourseName, Description, StartDate, EndDate, CoordinatorID, MaxStudents, LanguageID) VALUES ({course_id}, '{course_names[i]}', '{descriptions[i]}', '{start_date.strftime('%Y-%m-%d %H:%M:%S')}', '{end_date.strftime('%Y-%m-%d %H:%M:%S')}', {coordinator_id}, {max_students}, 1);"
    )
    added_dates.append(added_at)
    prices.append(price)
    indices.append(course_id)
    advance_payments.append(advance_payment)
    start_dates.append(start_date)
    course_table[course_id] = {
        "name": course_names[i],
        "start_date": start_date,
        "end_date": end_date,
        "price": price,
        "closed": closed,
        "close_date": close_date,
        "advance_payment": advance_payment,
        "coordinator_id": coordinator_id,
        "added_at": added_at,
        "max_students": max_students
    }

  generate_payments(courses, indices, course_table)

  modules_per_course = 3
  module_names = [
      "Wprowadzenie", "Zaawansowane techniki", "Projekt praktyczny"
  ]

  for id in course_table:
    course_table[id]["modules"] = []
    for module_number in range(1, modules_per_course + 1):
      module_name = f"{module_names[module_number-1]} - Moduł {module_number}"
      module_description = f"To jest opis modułu {module_number} kursu {course_table[id]['name']}."
      course_table[id]["modules"].append({
          "name": module_name,
          "desc": module_description
      })

  generate_modules(courses, course_table)
  generate_sessions(courses, course_table)
  generate_attendance(courses, course_table)
  generate_rules(courses, course_table)
  return courses


def generate_course_sessions():
  '''
   CREATE TABLE CoursesSessions (
    CourseSessionID int  NOT NULL,
    LanguageID int  NOT NULL,
    ModuleID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NULL,
    CONSTRAINT CoursesSessions_pk PRIMARY KEY  (CourseSessionID)
);
  '''
  courses_sessions = []
  for i in range(20):
    pass
  return courses_sessions


courses = '\n'.join(generate_courses())
people = '\n'.join(generate_people())
employees = '\n'.join(generate_employees())
languages = '\n'.join(generate_languages())
users = '\n'.join(generate_users())
roles = '\n'.join(generate_roles())
employee_roles = '\n'.join(generate_employee_roles())


print(f"""
BEGIN TRANSACTION;

BEGIN TRY
    -- Webinars
    {languages}
    {people}
    {employees}
    {users}
    {courses}
    {roles}
    {employee_roles}
    -- If everything is successful, commit the transaction
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
