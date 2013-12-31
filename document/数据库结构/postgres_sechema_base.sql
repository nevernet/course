--
-- 创建分词器
--
-- create the extension

CREATE EXTENSION zhparser
  SCHEMA course
  VERSION "1.0";

CREATE TEXT SEARCH CONFIGURATION chinesecfg (PARSER = course.zhparser);

ALTER TEXT SEARCH CONFIGURATION chinesecfg ADD MAPPING FOR a WITH simple;
ALTER TEXT SEARCH CONFIGURATION chinesecfg ADD MAPPING FOR e WITH simple;
ALTER TEXT SEARCH CONFIGURATION chinesecfg ADD MAPPING FOR i WITH simple;
ALTER TEXT SEARCH CONFIGURATION chinesecfg ADD MAPPING FOR l WITH simple;
ALTER TEXT SEARCH CONFIGURATION chinesecfg ADD MAPPING FOR n WITH simple;

--
-- 
--

CREATE OR REPLACE FUNCTION plainto_or_tsquery (text TEXT)
	RETURNS tsquery AS 
$BODY$
DECLARE
	ret tsquery;
BEGIN
	SELECT replace(plainto_tsquery('course.chinesecfg', text)::text, '&', '|')::tsquery INTO ret;
	RETURN ret;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
	COST 100;

--
-- 
--
CREATE OR REPLACE FUNCTION plainto_or_tsquery2(text TEXT)
	RETURNS tsquery AS 
$BODY$
DECLARE
	ret tsquery;
BEGIN
	SELECT to_tsquery('course.chinesecfg', ARRAY_TO_STRING(ARRAY(SELECT token FROM ts_parse('course.zhparser', text)), '*|*')) INTO ret;
	RETURN ret;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
	COST 100;

--
-- 用户表
--
CREATE TABLE users (
	id serial,
	username character varying(20) NOT NULL,			-- 用户名
	password character varying(60) NOT NULL,			-- 密码
	created timestamp without time zone DEFAULT now() NOT NULL,	-- 创建时间

	CONSTRAINT users_id_pkey PRIMARY KEY (id),
	CONSTRAINT users_username_unique UNIQUE (username)
);

--
-- 培训课程系统类别表
--
CREATE TABLE types (
	id serial,
	typename character varying(20) NOT NULL,			-- 等级名

	CONSTRAINT types_id_pkey PRIMARY KEY (id)
);

--
-- 培训课程类别表
--
CREATE TABLE classes (
	id serial,
	user_id integer DEFAULT 0,					-- 所属用户
	classname character varying(20) NOT NULL,			-- 类别名

	CONSTRAINT classes_id_pkey PRIMARY KEY (id),
	CONSTRAINT classes_classname_unique UNIQUE (user_id, classname)
);

--
-- 培训课程表
--
CREATE TABLE courses (
	id serial,
	user_id integer DEFAULT 0,					-- 所属用户
	coursename character varying(20) NOT NULL,
	type_id integer DEFAULT 0,					-- 系统类别
	class_id integer DEFAULT 0,					-- 类别
	level integer DEFAULT 0,					-- 等级 0 入门 1 中级 2 高级
	status integer DEFAULT 0,					-- 状态 0 未发布 1 已发布

	updated timestamp without time zone,				-- 最后更新时间
	created timestamp without time zone DEFAULT now() NOT NULL,	-- 创建时间

	CONSTRAINT courses_id_pkey PRIMARY KEY (id),
	CONSTRAINT courses_coursename_unique UNIQUE (user_id, coursename)
);

--
-- 培训课程章节课时表
--
CREATE TABLE lessons (
	id serial,
	user_id integer DEFAULT 0,					-- 所属用户
	course_id integer NOT NULL,
	title character varying(20) NOT NULL,
	class integer DEFAULT 0,					-- 0 chapter章节 1 lesson课时
	type integer DEFAULT 0,						-- 0 video视频 1 audio音频 2 text图文
	sort integer DEFAULT 0,						-- 排序编号
	path character varying(120) NOT NULL,				-- 内容存储路径

	created timestamp without time zone DEFAULT now() NOT NULL,	-- 创建时间

	CONSTRAINT lessons_id_pkey PRIMARY KEY (id),
	CONSTRAINT lessons_title_unique UNIQUE (course_id, title)
);
CREATE INDEX lessons_title_index ON title USING BTREE (title);

--
-- 培训课时测验表
--
CREATE TABLE quizs (
	id serial,
	course_id integer NOT NULL,
	lesson_id integer NOT NULL,
	description character varying(250) NOT NULL,			-- 描述
	level character varying(250) DEFAULT 0,				-- 0 入门 1 中级 2 高级
	choices json,							-- [{"choice":"选项内容", "answer":true}, {"choice":"选项内容2", "answer":false}]

	created timestamp without time zone DEFAULT now() NOT NULL,	-- 创建时间

	CONSTRAINT quizs_id_pkey PRIMARY KEY (id)
);

--
-- 用户学习课程状态表
--
CREATE TABLE learn_courses (
	id serial,
	user_id integer DEFAULT 0,					-- 所属用户
	course_id integer NOT NULL,
	status integer DEFAULT 0,					-- 0 学习中 1 学习完成

	created timestamp without time zone DEFAULT now() NOT NULL,	-- 创建时间

	CONSTRAINT learn_courses_id_pkey PRIMARY KEY (id),
	CONSTRAINT learn_courses_course_id_unique UNIQUE (user_id, course_id)
);

--
-- 用户学习课时状态表
--
CREATE TABLE learn_lessons (
	id serial,
	user_id integer DEFAULT 0,					-- 所属用户
	course_id integer NOT NULL,
	lesson_id integer NOT NULL,
	status integer DEFAULT 0 NOT NULL,				-- 0 学习中 1 学习完成

	created timestamp without time zone DEFAULT now() NOT NULL,	-- 创建时间

	CONSTRAINT learn_lessons_id_pkey PRIMARY KEY (id),
	CONSTRAINT learn_lessons_course_id_unique UNIQUE (user_id, course_id, lesson_id)
);