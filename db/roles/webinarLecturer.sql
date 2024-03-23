-- Wykładowcy webinariów - tworzenie/modyfikacja webinarów
CREATE ROLE [WebinarLecturerRole];

GRANT EXECUTE ON [dbo].[AddWebinar] TO [WebinarLecturerRole];
GRANT EXECUTE ON [dbo].[ModifyWebinarData] TO [WebinarLecturerRole];
GRANT EXECUTE ON [dbo].[DeleteWebinar] TO [WebinarLecturerRole];
GRANT EXECUTE ON [dbo].[ModifyWebinarRecording] TO [WebinarLecturerRole];
GRANT EXECUTE ON [dbo].[CloseWebinar] TO [WebinarLecturerRole];
