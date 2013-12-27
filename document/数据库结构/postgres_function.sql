SET search_path TO course;

--
-- 重置课程时长
--
CREATE OR REPLACE FUNCTION lesson_reset(_lesson_id integer)
	RETURNS integer AS
$BODY$
DECLARE
	_view record;
	_totaltime INT4 := 0;
	_time INT4 := 0;
BEGIN
	FOR _view IN SELECT id, totaltime FROM chapters WHERE lesson_id  = _lesson_id ORDER BY sort DESC, id ASC LOOP
		IF _totaltime > 0 THEN
			_time := _totaltime + 1;
		END IF;
		UPDATE chapters SET time = _time WHERE id = _view.id;
		_totaltime := _totaltime + _view.totaltime;
	END LOOP;
	UPDATE lessons SET totaltime = _totaltime WHERE id  = _lesson_id;
	RETURN 0;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
	COST 100;




--
-- 触发课程统计
--
-- DROP FUNCTION process_learn_courses() CASCADE;

CREATE OR REPLACE FUNCTION process_learn_courses() RETURNS TRIGGER AS
$BODY$
DECLARE
	_username varchar;
BEGIN
	SET search_path TO course;
	-- 查找教师username
	SELECT username INTO _username FROM courses WHERE id = OLD.course_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION '没有找到相关课程';
	END IF;

	IF (TG_OP = 'UPDATE') THEN
		IF (OLD.status < 2 AND NEW.status = 2) THEN
			UPDATE learn_grades SET course = course + 1 WHERE username = NEW.username AND teach = _username;
		END IF;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE learn_grades SET course2 = course2 + 1 WHERE username = NEW.username AND teach = _username;
		RETURN NEW;
	ELSIF (TG_OP = 'DELETE') THEN
		IF (OLD.status = 2) THEN
			UPDATE learn_grades SET course = course - 1 WHERE username = NEW.username AND teach = _username;
		END IF;
		UPDATE learn_grades SET course2 = course2 - 1 WHERE username = NEW.username AND teach = _username;
		RETURN OLD;
	END IF;
	RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_learn_courses AFTER INSERT OR UPDATE OR DELETE ON learn_courses FOR EACH ROW EXECUTE PROCEDURE process_learn_courses();

--
-- 触发课时统计
--

CREATE OR REPLACE FUNCTION process_learn_lessons() RETURNS TRIGGER AS
$BODY$
DECLARE
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		IF (OLD.status < 2 AND NEW.status = 2) THEN
			UPDATE learn_courses SET lesson = lesson + 1 WHERE username = NEW.username AND course_id = NEW.course_id;
		END IF;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE learn_courses SET lesson2 = lesson2 + 1 WHERE username = NEW.username AND course_id = NEW.course_id;
		RETURN NEW;
	ELSIF (TG_OP = 'DELETE') THEN
		IF (OLD.status = 2) THEN
			UPDATE learn_courses SET lesson = lesson - 1 WHERE username = OLD.username AND course_id = OLD.course_id;
		END IF;
		UPDATE learn_courses SET lesson2 = lesson2 - 1 WHERE username = OLD.username AND course_id = OLD.course_id;
		RETURN OLD;
	END IF;
	RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER trigger_learn_lessons AFTER INSERT OR UPDATE OR DELETE ON learn_lessons FOR EACH ROW EXECUTE PROCEDURE process_learn_lessons();
