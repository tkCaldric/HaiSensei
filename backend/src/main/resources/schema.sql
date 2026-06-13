-- Schema and Seed Data Initialization for H2 / PostgreSQL compatible mode

DROP TABLE IF EXISTS sample_phrases CASCADE;
DROP TABLE IF EXISTS sentence_templates CASCADE;
DROP TABLE IF EXISTS conjugation_rules CASCADE;
DROP TABLE IF EXISTS grammatical_forms CASCADE;
DROP TABLE IF EXISTS nouns CASCADE;
DROP TABLE IF EXISTS verbs CASCADE;
DROP TABLE IF EXISTS verb_groups CASCADE;

-- 1. verb_groups
CREATE TABLE verb_groups (
    id SERIAL PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL UNIQUE
);

-- 2. verbs
CREATE TABLE verbs (
    id SERIAL PRIMARY KEY,
    group_id INTEGER REFERENCES verb_groups(id) ON DELETE CASCADE,
    english VARCHAR(100) NOT NULL,
    dictionary_form VARCHAR(100) NOT NULL,
    kanji_root VARCHAR(100) NOT NULL,
    romaji_root VARCHAR(100) NOT NULL,
    base_stem VARCHAR(100) NOT NULL,
    romaji_base_stem VARCHAR(100) NOT NULL,
    last_kana_char VARCHAR(10) NOT NULL,
    jlpt_level VARCHAR(10) NOT NULL
);

-- 3. nouns
CREATE TABLE nouns (
    id SERIAL PRIMARY KEY,
    english VARCHAR(100) NOT NULL,
    japanese_form VARCHAR(100) NOT NULL,
    romaji_form VARCHAR(100) NOT NULL
);

-- 4. grammatical_forms
CREATE TABLE grammatical_forms (
    id SERIAL PRIMARY KEY,
    form_name VARCHAR(100) NOT NULL UNIQUE,
    jlpt_level VARCHAR(10) NOT NULL
);

-- 5. conjugation_rules
CREATE TABLE conjugation_rules (
    id SERIAL PRIMARY KEY,
    form_id INTEGER REFERENCES grammatical_forms(id) ON DELETE CASCADE,
    group_id INTEGER REFERENCES verb_groups(id) ON DELETE CASCADE,
    applies_to_ending VARCHAR(10) NOT NULL,
    stem_mutation VARCHAR(50) DEFAULT '',
    romaji_stem_mutation VARCHAR(50) DEFAULT '',
    suffix VARCHAR(50) DEFAULT '',
    romaji_suffix VARCHAR(50) DEFAULT ''
);

-- 6. sentence_templates
CREATE TABLE sentence_templates (
    id SERIAL PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL,
    intent_category VARCHAR(100) NOT NULL,
    english_structure VARCHAR(255) NOT NULL,
    japanese_structure VARCHAR(255) NOT NULL,
    romaji_structure VARCHAR(255) NOT NULL
);

-- 7. sample_phrases
CREATE TABLE sample_phrases (
    id SERIAL PRIMARY KEY,
    input_pattern VARCHAR(255) NOT NULL,
    template_id INTEGER REFERENCES sentence_templates(id) ON DELETE CASCADE,
    subject_noun_id INTEGER REFERENCES nouns(id) ON DELETE CASCADE,
    object_noun_id INTEGER REFERENCES nouns(id) ON DELETE CASCADE,
    verb_id INTEGER REFERENCES verbs(id) ON DELETE CASCADE,
    grammatical_form_id INTEGER REFERENCES grammatical_forms(id) ON DELETE CASCADE
);

-- Insert Verb Groups (1: Godan / Group 1, 2: Ichidan / Group 2, 3: Irregular / Group 3)
INSERT INTO verb_groups (id, group_name) VALUES
(1, 'Godan (Group 1)'),
(2, 'Ichidan (Group 2)'),
(3, 'Irregular (Group 3)');

-- Insert Verbs (Expanded)
INSERT INTO verbs (id, group_id, english, dictionary_form, kanji_root, romaji_root, base_stem, romaji_base_stem, last_kana_char, jlpt_level) VALUES
(1, 2, 'eat', '食[た]べる', '食[た]', 'ta', '食[た]べ', 'tabe', 'る', 'N5'),
(2, 2, 'see / watch', '見[み]る', '見[み]', 'mi', '見[み]', 'mi', 'る', 'N5'),
(3, 1, 'drink', '飲[の]む', '飲[の]', 'no', '飲[の]', 'no', 'む', 'N5'),
(4, 1, 'write', '書[か]く', '書[か]', 'ka', '書[か]', 'ka', 'く', 'N5'),
(5, 1, 'read', '読[よ]む', '読[よ]', 'yo', '読[よ]', 'yo', 'む', 'N5'),
(6, 1, 'buy', '買[か]う', '買[か]', 'ka', '買[か]', 'ka', 'う', 'N5'),
(7, 3, 'do', 'する', 'する', 'suru', '', '', 'する', 'N5'),
(8, 3, 'come', '来[く]る', '来[く]', 'ku', '', '', 'くる', 'N5'),
(9, 1, 'speak / talk', '話[はな]す', '話[はな]', 'ha', '話[はな]', 'hana', 'す', 'N5'),
(10, 1, 'listen / ask', '聞[き]く', '聞[き]', 'ki', '聞[き]', 'ki', 'く', 'N5'),
(11, 1, 'meet', '会[あ]う', '会[あ]', 'a', '会[あ]', 'a', 'う', 'N5'),
(12, 1, 'wait', '待[ま]つ', '待[ま]', 'ma', '待[ま]', 'ma', 'つ', 'N5'),
(13, 1, 'return home', '帰[かえ]る', '帰[かえ]', 'kae', '帰[かえ]', 'kaere', 'る', 'N5');

-- Insert Nouns (Generalised Semantic Categories)
INSERT INTO nouns (id, english, japanese_form, romaji_form) VALUES
(1, 'I', '私[わたし]', 'watashi'),
(2, '[Food / Tabemono]', '食[た]べ物[もの]', 'tabemono'),
(3, '[Drink / Nomimono]', '飲[の]み物[もの]', 'nomimono'),
(4, '[Reading Material]', '読[よ]み物[もの]', 'yomimono'),
(5, '[Writing / Letter]', '手紙[てがみ]', 'tegami'),
(6, '[Language]', '言葉[ことば]', 'kotoba'),
(7, '[Person]', '人[ひと]', 'hito'),
(8, '[Media / Movie]', '映画[えいが]', 'eiga'),
(9, '[Place / Destination]', '場所[ばしょ]', 'basho'),
(10, '[Object / Item]', '物[もの]', 'mono');

-- Insert Grammatical Forms (N5/N4 Expanded)
INSERT INTO grammatical_forms (id, form_name, jlpt_level) VALUES
(1, 'Polite Present Positive (-masu)', 'N5'),
(2, 'Polite Present Negative (-masen)', 'N5'),
(3, 'Polite Past Positive (-mashita)', 'N5'),
(4, 'Polite Past Negative (-masendeshita)', 'N5'),
(5, 'Plain Present Positive (Dictionary Form)', 'N5'),
(6, 'Polite Request (-te kudasai)', 'N5'),
(7, 'Present Continuous (-te imasu)', 'N5'),
(8, 'Desire Form (-tai desu)', 'N5/N4'),
(9, 'Polite Potential Form (-emasu / -raremasu)', 'N4'),
(10, 'Polite Permission (-te mo ii desu)', 'N4');

-- Insert Conjugation Rules
-- Group 1 (Godan) Rules
-- 1. Polite Present Positive (-masu)
INSERT INTO conjugation_rules (form_id, group_id, applies_to_ending, stem_mutation, romaji_stem_mutation, suffix, romaji_suffix) VALUES
(1, 1, 'む', 'み', 'mi', 'ます', 'masu'),
(1, 1, 'く', 'き', 'ki', 'ます', 'masu'),
(1, 1, 'う', 'い', 'i', 'ます', 'masu'),
(1, 1, 'す', 'し', 'shi', 'ます', 'masu'),
(1, 1, 'つ', 'ち', 'chi', 'ます', 'masu'),
(1, 1, 'る', 'り', 'ri', 'ます', 'masu'),
-- 2. Polite Present Negative (-masen)
(2, 1, 'む', 'み', 'mi', 'ません', 'masen'),
(2, 1, 'く', 'き', 'ki', 'ません', 'masen'),
(2, 1, 'う', 'い', 'i', 'ません', 'masen'),
(2, 1, 'す', 'し', 'shi', 'ません', 'masen'),
(2, 1, 'つ', 'ち', 'chi', 'ません', 'masen'),
(2, 1, 'る', 'り', 'ri', 'ません', 'masen'),
-- 3. Polite Past Positive (-mashita)
(3, 1, 'む', 'み', 'mi', 'ました', 'mashita'),
(3, 1, 'く', 'き', 'ki', 'ました', 'mashita'),
(3, 1, 'う', 'い', 'i', 'ました', 'mashita'),
(3, 1, 'す', 'し', 'shi', 'ました', 'mashita'),
(3, 1, 'つ', 'ち', 'chi', 'ました', 'mashita'),
(3, 1, 'る', 'り', 'ri', 'ました', 'mashita'),
-- 4. Polite Past Negative (-masendeshita)
(4, 1, 'む', 'み', 'mi', 'ませんでした', 'masendeshita'),
(4, 1, 'く', 'き', 'ki', 'ませんでした', 'masendeshita'),
(4, 1, 'う', 'い', 'i', 'ませんでした', 'masendeshita'),
(4, 1, 'す', 'し', 'shi', 'ませんでした', 'masendeshita'),
(4, 1, 'つ', 'ち', 'chi', 'ませんでした', 'masendeshita'),
(4, 1, 'る', 'り', 'ri', 'ませんでした', 'masendeshita'),
-- 5. Plain Present Positive (Dictionary Form)
(5, 1, 'む', 'む', 'mu', '', ''),
(5, 1, 'く', 'く', 'ku', '', ''),
(5, 1, 'う', 'う', 'u', '', ''),
(5, 1, 'す', 'す', 'su', '', ''),
(5, 1, 'つ', 'つ', 'tsu', '', ''),
(5, 1, 'る', 'る', 'ru', '', ''),
-- 6. Polite Request (-te kudasai)
(6, 1, 'む', 'ん', 'n', 'でください', 'de kudasai'),
(6, 1, 'く', 'い', 'i', 'てください', 'te kudasai'),
(6, 1, 'う', 'っ', 't', 'てください', 'te kudasai'),
(6, 1, 'す', 'し', 'shi', 'てください', 'te kudasai'),
(6, 1, 'つ', 'っ', 't', 'てください', 'te kudasai'),
(6, 1, 'る', 'っ', 't', 'てください', 'te kudasai'),
-- 7. Present Continuous (-te imasu)
(7, 1, 'む', 'ん', 'n', 'でいます', 'de imasu'),
(7, 1, 'く', 'い', 'i', 'ています', 'te imasu'),
(7, 1, 'う', 'っ', 't', 'ています', 'te imasu'),
(7, 1, 'す', 'し', 'shi', 'ています', 'te imasu'),
(7, 1, 'つ', 'っ', 't', 'ています', 'te imasu'),
(7, 1, 'る', 'っ', 't', 'ています', 'te imasu'),
-- 8. Desire Form (-tai desu)
(8, 1, 'む', 'み', 'mi', 'たいです', 'tai desu'),
(8, 1, 'く', 'き', 'ki', 'たいです', 'tai desu'),
(8, 1, 'う', 'い', 'i', 'たいです', 'tai desu'),
(8, 1, 'す', 'し', 'shi', 'たいです', 'tai desu'),
(8, 1, 'つ', 'ち', 'chi', 'たいです', 'tai desu'),
(8, 1, 'る', 'り', 'ri', 'たいです', 'tai desu'),
-- 9. Polite Potential Form (-emasu)
(9, 1, 'む', 'め', 'me', 'ます', 'masu'),
(9, 1, 'く', 'け', 'ke', 'ます', 'masu'),
(9, 1, 'う', 'え', 'e', 'ます', 'masu'),
(9, 1, 'す', 'せ', 'se', 'ます', 'masu'),
(9, 1, 'つ', 'て', 'te', 'ます', 'masu'),
(9, 1, 'る', 'れ', 're', 'ます', 'masu'),
-- 10. Polite Permission (-te mo ii desu)
(10, 1, 'む', 'ん', 'n', 'でもいいです', 'de mo ii desu'),
(10, 1, 'く', 'い', 'i', 'てもいいです', 'te mo ii desu'),
(10, 1, 'う', 'っ', 't', 'てもいいです', 'te mo ii desu'),
(10, 1, 'す', 'し', 'shi', 'てもいいです', 'te mo ii desu'),
(10, 1, 'つ', 'っ', 't', 'てもいいです', 'te mo ii desu'),
(10, 1, 'る', 'っ', 't', 'てもいいです', 'te mo ii desu');

-- Group 2 (Ichidan) Rules
-- 1. Polite Present Positive (-masu)
INSERT INTO conjugation_rules (form_id, group_id, applies_to_ending, stem_mutation, romaji_stem_mutation, suffix, romaji_suffix) VALUES
(1, 2, 'る', '', '', 'ます', 'masu'),
-- 2. Polite Present Negative (-masen)
(2, 2, 'る', '', '', 'ません', 'masen'),
-- 3. Polite Past Positive (-mashita)
(3, 2, 'る', '', '', 'ました', 'mashita'),
-- 4. Polite Past Negative (-masendeshita)
(4, 2, 'る', '', '', 'ませんでした', 'masendeshita'),
-- 5. Plain Present Positive (Dictionary Form)
(5, 2, 'る', 'る', 'ru', '', ''),
-- 6. Polite Request (-te kudasai)
(6, 2, 'る', '', '', 'てください', 'te kudasai'),
-- 7. Present Continuous (-te imasu)
(7, 2, 'る', '', '', 'ています', 'te imasu'),
-- 8. Desire Form (-tai desu)
(8, 2, 'る', '', '', 'たいです', 'tai desu'),
-- 9. Polite Potential Form (-raremasu)
(9, 2, 'る', 'られ', 'rare', 'ます', 'masu'),
-- 10. Polite Permission (-te mo ii desu)
(10, 2, 'る', '', '', 'てもいいです', 'te mo ii desu');

-- Group 3 (Irregular) Rules
INSERT INTO conjugation_rules (form_id, group_id, applies_to_ending, stem_mutation, romaji_stem_mutation, suffix, romaji_suffix) VALUES
(1, 3, 'する', 'し', 'shi', 'ます', 'masu'),
(2, 3, 'する', 'し', 'shi', 'ません', 'masen'),
(3, 3, 'する', 'し', 'shi', 'ました', 'mashita'),
(4, 3, 'する', 'し', 'shi', 'ませんでした', 'masendeshita'),
(5, 3, 'する', 'する', 'suru', '', ''),
(6, 3, 'する', 'し', 'shi', 'てください', 'te kudasai'),
(7, 3, 'する', 'し', 'shi', 'ています', 'te imasu'),
(8, 3, 'する', 'し', 'shi', 'たいです', 'tai desu'),
(9, 3, 'する', 'でき', 'deki', 'ます', 'masu'),
(10, 3, 'する', 'し', 'shi', 'てもいいです', 'te mo ii desu'),
-- For 'くる' (come)
(1, 3, 'くる', '来[き]', 'ki', 'ます', 'masu'),
(2, 3, 'くる', '来[き]', 'ki', 'ません', 'masen'),
(3, 3, 'くる', '来[き]', 'ki', 'ました', 'mashita'),
(4, 3, 'くる', '来[き]', 'ki', 'ませんでした', 'masendeshita'),
(5, 3, 'くる', '来[く]る', 'kuru', '', ''),
(6, 3, 'くる', '来[き]', 'ki', 'てください', 'te kudasai'),
(7, 3, 'くる', '来[き]', 'ki', 'ています', 'te imasu'),
(8, 3, 'くる', '来[き]', 'ki', 'たいです', 'tai desu'),
(9, 3, 'くる', '来[こ]られ', 'kora', 'ます', 'masu'),
(10, 3, 'くる', '来[き]', 'ki', 'てもいいです', 'te mo ii desu');

-- Insert Sentence Templates
INSERT INTO sentence_templates (id, template_name, intent_category, english_structure, japanese_structure, romaji_structure) VALUES
(1, 'Subject-Object-Verb (Standard Action)', 'transitive_action', '{subject} (Subject) does action to {object} (Object).', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}'),
(2, 'Subject-Object-Verb (Polite/Formal focus)', 'transitive_action', 'Focus: {subject} executes action regarding {object}.', '{subject}については、{object}を{verb}', '{subject} ni tsuite wa, {object} o {verb}'),
(3, 'Subject-Object-Verb (Emphasis on Object)', 'transitive_action', 'Emphasis: {object} is acted upon by {subject}.', '{object}は{subject}が{verb}', '{object} wa {subject} ga {verb}'),
(4, 'Polite Request (Please do...)', 'request', 'Please {verb} {object}.', '{object}を{verb}', '{object} o {verb}'),
(5, 'Present Continuous (Am/Is doing...)', 'continuous_action', '{subject} is {verb} {object}.', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}'),
(6, 'Desire Expression (Want to do...)', 'desire_action', '{subject} wants to {verb} {object}.', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}'),
(7, 'Potential Expression (Can do...)', 'potential_action', '{subject} can {verb} {object}.', '{subject}は{object}が{verb}', '{subject} wa {object} ga {verb}'),
(8, 'Permission Expression (May do...)', 'permission_action', '{subject} may {verb} {object}.', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}');

-- Insert Sample Phrases (Generalised)
INSERT INTO sample_phrases (input_pattern, template_id, subject_noun_id, object_noun_id, verb_id, grammatical_form_id) VALUES
('I eat food', 1, 1, 2, 1, 1),
('I watch a movie', 1, 1, 8, 2, 1),
('I drink a beverage', 1, 1, 3, 3, 1),
('I write a letter', 1, 1, 5, 4, 1),
('I buy an item', 1, 1, 10, 6, 1),
('I read a book', 1, 1, 4, 5, 1),
('I speak language', 1, 1, 6, 9, 1),
('I listen to a person', 1, 1, 7, 10, 1),
('I meet a person', 1, 1, 7, 11, 1),
('I wait for a person', 1, 1, 7, 12, 1),
('please eat food', 4, 1, 2, 1, 6),
('please write a letter', 4, 1, 5, 4, 6),
('I am drinking a beverage', 5, 1, 3, 3, 7),
('I want to read a book', 6, 1, 4, 5, 8),
('I can speak Japanese', 7, 1, 6, 9, 9),
('you may eat food', 8, 1, 2, 1, 10);

-- =========================================================
-- JLPT N5/N4 VOCABULARY IMPORTED FROM N4TON5 TEXT DATASET
-- =========================================================

DROP TABLE IF EXISTS jlpt_vocab CASCADE;
DROP TABLE IF EXISTS jlpt_kanji CASCADE;

CREATE TABLE jlpt_vocab (
    id SERIAL PRIMARY KEY,
    kanji VARCHAR(100) NOT NULL,
    reading VARCHAR(100) NOT NULL,
    jlpt_level VARCHAR(10) NOT NULL,
    meaning VARCHAR(255) NOT NULL
);

INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あ', 'あ', 'N4', 'ah / oh');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ああ', 'ああ', 'N4', 'ah / oh');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あいさつ', 'あいさつ', 'N4', 'greeting');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('間', 'あいだ', 'N4', 'between / space / interval');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('合う', 'あう', 'N4', 'to match / to fit');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あかちゃん', 'あかちゃん', 'N4', 'baby');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('上る', 'あがる', 'N4', 'to go up / to rise');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('赤ん坊', 'あかんぼう', 'N4', 'baby');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('空く', 'あく', 'N4', 'to become empty / to be vacant');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('アクセサリー', 'アクセサリー', 'N4', 'accessory');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あげる', 'あげる', 'N4', 'to give / to raise');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('浅い', 'あさい', 'N4', 'shallow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('味', 'あじ', 'N4', 'taste / flavor');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('アジア', 'アジア', 'N4', 'Asia');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('明日', 'あす', 'N4', 'tomorrow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('遊び', 'あそび', 'N4', 'play / game');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('集る', 'あつまる', 'N4', 'to gather (same as 集まる)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('集める', 'あつめる', 'N4', 'to collect');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('アナウンサー', 'アナウンサー', 'N4', 'announcer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('アフリカ', 'アフリカ', 'N4', 'Africa');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('アメリカ', 'アメリカ', 'N4', 'America');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('謝る', 'あやまる', 'N4', 'to apologize');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('アルコール', 'アルコール', 'N4', 'alcohol');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('アルバイト', 'アルバイト', 'N4', 'part-time job');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('安心', 'あんしん', 'N4', 'relief / peace of mind');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('安全', 'あんぜん', 'N4', 'safety');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あんな', 'あんな', 'N4', 'that sort of');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('案内', 'あんない', 'N4', 'guidance / to guide');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('以下', 'いか', 'N4', 'below / less than');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('以外', 'いがい', 'N4', 'except / outside of');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('医学', 'いがく', 'N4', 'medical science');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('生きる', 'いきる', 'N4', 'to live');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('意見', 'いけん', 'N4', 'opinion');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('石', 'いし', 'N4', 'stone');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いじめる', 'いじめる', 'N4', 'to tease / to bully');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('以上', 'いじょう', 'N4', 'more than / above');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('急ぐ', 'いそぐ', 'N4', 'to hurry');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('致す', 'いたす', 'N4', 'to do (humble)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いただく', 'いただく', 'N4', 'to receive / to eat/drink (humble)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一度', 'いちど', 'N4', 'once / one time');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一生懸命', 'いっしょうけんめい', 'N4', 'with great effort');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いっぱい', 'いっぱい', 'N4', 'full / a lot');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('糸', 'いと', 'N4', 'thread');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('以内', 'いない', 'N4', 'within / less than');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('田舎', 'いなか', 'N4', 'countryside');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('祈る', 'いのる', 'N4', 'to pray');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いらっしゃる', 'いらっしゃる', 'N4', 'to come / to go / to be (honorific)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('植える', 'うえる', 'N4', 'to plant');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('うかがう', 'うかがう', 'N4', 'to ask / to visit (humble)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('受付', 'うけつけ', 'N4', 'reception desk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('受ける', 'うける', 'N4', 'to receive / to take');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('動く', 'うごく', 'N4', 'to move');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('うそ', 'うそ', 'N4', 'lie / falsehood');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('うち', 'うち', 'N4', 'inside / home');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('打つ', 'うつ', 'N4', 'to hit / to strike');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('美しい', 'うつくしい', 'N4', 'beautiful');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('写す', 'うつす', 'N4', 'to copy / to photograph');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('移る', 'うつる', 'N4', 'to move / to shift');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('腕', 'うで', 'N4', 'arm / skill');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('うまい', 'うまい', 'N4', 'skillful / delicious');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('裏', 'うら', 'N4', 'back / reverse side');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('売り場', 'うりば', 'N4', 'selling counter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('うれしい', 'うれしい', 'N4', 'happy / glad');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('うん', 'うん', 'N4', 'yes / uh-huh');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('運転', 'うんてん', 'N4', 'driving');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('運転手', 'うんてんしゅ', 'N4', 'driver');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('運動', 'うんどう', 'N4', 'exercise / sports');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('エスカレーター', 'エスカレーター', 'N4', 'escalator');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('枝', 'えだ', 'N4', 'branch');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('選ぶ', 'えらぶ', 'N4', 'to choose');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('遠慮', 'えんりょ', 'N4', 'reserve / restraint');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おいでになる', 'おいでになる', 'N4', 'to come / to go (honorific)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お祝い', 'おいわい', 'N4', 'celebration / congratulation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('オートバイ', 'オートバイ', 'N4', 'motorcycle');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おかげ', 'おかげ', 'N4', 'thanks to');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おかしい', 'おかしい', 'N4', 'funny / strange');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('億', 'おく', 'N4', 'hundred million');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('屋上', 'おくじょう', 'N4', 'rooftop');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('贈り物', 'おくりもの', 'N4', 'gift / present');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('送る', 'おくる', 'N4', 'to send');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('遅れる', 'おくれる', 'N4', 'to be late');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('起す', 'おこす', 'N4', 'to raise / to cause');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('行う', 'おこなう', 'N4', 'to do / to perform');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('怒る', 'おこる', 'N4', 'to get angry');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('押し入れ', 'おしいれ', 'N4', 'closet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お嬢さん', 'おじょうさん', 'N4', 'daughter / young lady');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お宅', 'おたく', 'N4', 'your house / you');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('落る', 'おちる', 'N4', 'to fall');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おっしゃる', 'おっしゃる', 'N4', 'to say (honorific)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('夫', 'おっと', 'N4', 'husband');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おつり', 'おつり', 'N4', 'change (money)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('音', 'おと', 'N4', 'sound');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('落す', 'おとす', 'N4', 'to drop');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('踊り', 'おどり', 'N4', 'dance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('踊る', 'おどる', 'N4', 'to dance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('驚く', 'おどろく', 'N4', 'to be surprised');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お祭り', 'おまつり', 'N4', 'festival');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お見舞い', 'おみまい', 'N4', 'visit to express sympathy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お土産', 'おみやげ', 'N4', 'souvenir');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('思い出す', 'おもいだす', 'N4', 'to recall');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('思う', 'おもう', 'N4', 'to think');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おもちゃ', 'おもちゃ', 'N4', 'toy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('表', 'おもて', 'N4', 'surface / front');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('親', 'おや', 'N4', 'parent');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('下りる', 'おりる', 'N4', 'to descend / to get off');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('折る', 'おる', 'N4', 'to break / to fold');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お礼', 'おれい', 'N4', 'thanks / expression of gratitude');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('折れる', 'おれる', 'N4', 'to break / to yield');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('終わり', 'おわり', 'N4', 'end');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('カーテン', 'カーテン', 'N4', 'curtain');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('海岸', 'かいがん', 'N4', 'coast / beach');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('会議', 'かいぎ', 'N4', 'meeting / conference');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('会議室', 'かいぎしつ', 'N4', 'conference room');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('会場', 'かいじょう', 'N4', 'meeting place / venue');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('会話', 'かいわ', 'N4', 'conversation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('帰り', 'かえり', 'N4', 'return / way back');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('変える', 'かえる', 'N4', 'to change');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('科学', 'かがく', 'N4', 'science');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('鏡', 'かがみ', 'N4', 'mirror');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('掛ける', 'かける', 'N4', 'to hang / to set (table)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('飾る', 'かざる', 'N4', 'to decorate');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('火事', 'かじ', 'N4', 'fire (accidental)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ガス', 'ガス', 'N4', 'gas');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ガソリン', 'ガソリン', 'N4', 'gasoline');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ガソリンスタンド', 'ガソリンスタンド', 'N4', 'gas station');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('堅', 'かたい', 'N4', 'hard / solid (alternative spelling)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('硬', 'かたい', 'N4', 'hard');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('固い', 'かたい', 'N4', 'hard / firm');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('形', 'かたち', 'N4', 'shape / form');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('片付ける', 'かたづける', 'N4', 'to tidy up');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('課長', 'かちょう', 'N4', 'section manager');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('勝つ', 'かつ', 'N4', 'to win');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('かっこう', 'かっこう', 'N4', 'shape / appearance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('家内', 'かない', 'N4', 'wife (humble)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('悲しい', 'かなしい', 'N4', 'sad');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('必ず', 'かならず', 'N4', 'without fail');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('金持ち', 'かねもち', 'N4', 'rich person');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('彼女', 'かのじょ', 'N4', 'she / girlfriend');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('壁', 'かべ', 'N4', 'wall');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('かまう', 'かまう', 'N4', 'to mind / to care about');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('髪', 'かみ', 'N4', 'hair');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('噛む', 'かむ', 'N4', 'to bite');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('通う', 'かよう', 'N4', 'to commute / to attend');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ガラス', 'ガラス', 'N4', 'glass');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('彼', 'かれ', 'N4', 'he / boyfriend');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('彼ら', 'かれら', 'N4', 'they (male)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('乾く', 'かわく', 'N4', 'to get dry');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('代わり', 'かわり', 'N4', 'substitute / instead');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('変わる', 'かわる', 'N4', 'to change');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('考える', 'かんがえる', 'N4', 'to think / to consider');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('関係', 'かんけい', 'N4', 'relation / connection');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('看護婦', 'かんごふ', 'N4', 'nurse');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('簡単', 'かんたん', 'N4', 'simple / easy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('気', 'き', 'N4', 'spirit / mood / attention');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('機会', 'きかい', 'N4', 'opportunity / chance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('危険', 'きけん', 'N4', 'dangerous / risk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('聞こえる', 'きこえる', 'N4', 'to be heard');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('汽車', 'きしゃ', 'N4', 'steam train');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('技術', 'ぎじゅつ', 'N4', 'technology / skill');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('季節', 'きせつ', 'N4', 'season');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('規則', 'きそく', 'N4', 'rule / regulation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('きっと', 'きっと', 'N4', 'surely');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('絹', 'きぬ', 'N4', 'silk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('厳しい', 'きびしい', 'N4', 'severe / strict');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('気分', 'きぶん', 'N4', 'feeling / mood');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('決る', 'きまる', 'N4', 'to be decided');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('君', 'きみ', 'N4', 'you (male)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('決める', 'きめる', 'N4', 'to decide');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('気持ち', 'きもち', 'N4', 'feeling / sensation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('着物', 'きもの', 'N4', 'kimono');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('客', 'きゃく', 'N4', 'guest / customer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('急', 'きゅう', 'N4', 'sudden / steep / urgent');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('急行', 'きゅうこう', 'N4', 'express train');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('教育', 'きょういく', 'N4', 'education');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('教会', 'きょうかい', 'N4', 'church');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('競争', 'きょうそう', 'N4', 'competition / race');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('興味', 'きょうみ', 'N4', 'interest / curiosity');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('近所', 'きんじょ', 'N4', 'neighborhood');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('具合', 'ぐあい', 'N4', 'condition / state');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('空気', 'くうき', 'N4', 'air / atmosphere');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('空港', 'くうこう', 'N4', 'airport');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('草', 'くさ', 'N4', 'grass / weed');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('くださる', 'くださる', 'N4', 'to give (honorific)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('首', 'くび', 'N4', 'neck');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('雲', 'くも', 'N4', 'cloud');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('比べる', 'くらべる', 'N4', 'to compare');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('くれる', 'くれる', 'N4', 'to give (to me)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('暮れる', 'くれる', 'N4', 'to get dark / to end');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('君', 'くん', 'N4', 'Mr. (suffix)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毛', 'け', 'N4', 'hair / fur');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('計画', 'けいかく', 'N4', 'plan');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('経験', 'けいけん', 'N4', 'experience');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('経済', 'けいざい', 'N4', 'economy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('警察', 'けいさつ', 'N4', 'police');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ケーキ', 'ケーキ', 'N4', 'cake');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('けが', 'けが', 'N4', 'injury');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('景色', 'けしき', 'N4', 'scenery');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('消しゴム', 'けしゴム', 'N4', 'eraser');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('下宿', 'げしゅく', 'N4', 'boarding house');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('決して', 'けっして', 'N4', 'never (with negative)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('けれど', 'けれど', 'N4', 'however / but');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('けれども', 'けれども', 'N4', 'however / but');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('原因', 'げんいん', 'N4', 'cause / reason');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('けんか', 'けんか', 'N4', 'fight / quarrel');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('研究', 'けんきゅう', 'N4', 'research / study');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('研究室', 'けんきゅうしつ', 'N4', 'laboratory / study room');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('見物', 'けんぶつ', 'N4', 'sightseeing');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('子', 'こ', 'N4', 'child');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('こう', 'こう', 'N4', 'thus / like this');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('郊外', 'こうがい', 'N4', 'suburb');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('講義', 'こうぎ', 'N4', 'lecture');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('工業', 'こうぎょう', 'N4', 'industry');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('高校', 'こうこう', 'N4', 'high school');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('高校生', 'こうこうせい', 'N4', 'high school student');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('工場', 'こうじょう', 'N4', 'factory');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('校長', 'こうちょう', 'N4', 'principal (school)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('交通', 'こうつう', 'N4', 'traffic');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('講堂', 'こうどう', 'N4', 'auditorium');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('高等学校', 'こうとうがっこう', 'N4', 'high school');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('公務員', 'こうむいん', 'N4', 'civil servant');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('国際', 'こくさい', 'N4', 'international');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('心', 'こころ', 'N4', 'heart / mind');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('御主人', 'ごしゅじん', 'N4', 'your husband / master');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('故障', 'こしょう', 'N4', 'breakdown / trouble');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ご存じ', 'ごぞんじ', 'N4', 'known (honorific)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('答', 'こたえ', 'N4', 'answer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ごちそう', 'ごちそう', 'N4', 'feast / treat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('こと', 'こと', 'N4', 'thing / matter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('小鳥', 'ことり', 'N4', 'small bird');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('このあいだ', 'このあいだ', 'N4', 'the other day');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('このごろ', 'このごろ', 'N4', 'these days / recently');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('細かい', 'こまかい', 'N4', 'small / fine / detailed');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ごみ', 'ごみ', 'N4', 'trash / garbage');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('込む', 'こむ', 'N4', 'to be crowded');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('米', 'こめ', 'N4', 'rice (uncooked)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ごらんになる', 'ごらんになる', 'N4', 'to see (honorific)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('これから', 'これから', 'N4', 'after this / from now on');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('怖い', 'こわい', 'N4', 'scary / afraid');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('壊す', 'こわす', 'N4', 'to break / to destroy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('壊れる', 'こわれる', 'N4', 'to be broken');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('コンサート', 'コンサート', 'N4', 'concert');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今度', 'こんど', 'N4', 'this time / next time');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('コンピュータ', 'コンピュータ', 'N4', 'computer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('コンピューター', 'コンピューター', 'N4', 'computer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今夜', 'こんや', 'N4', 'tonight');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('最近', 'さいきん', 'N4', 'recently');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('最後', 'さいご', 'N4', 'last / end');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('最初', 'さいしょ', 'N4', 'beginning / first');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('坂', 'さか', 'N4', 'slope / hill');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('探す', 'さがす', 'N4', 'to search / to look for');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('下る', 'さがる', 'N4', 'to go down / to descend');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('盛ん', 'さかん', 'N4', 'popular / prosperous');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('下げる', 'さげる', 'N4', 'to lower / to hang');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('差し上げる', 'さしあげる', 'N4', 'to give (humble)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('さっき', 'さっき', 'N4', 'a while ago');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('寂しい', 'さびしい', 'N4', 'lonely');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('さ来月', 'さらいげつ', 'N4', 'month after next');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('さ来週', 'さらいしゅう', 'N4', 'week after next');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('サラダ', 'サラダ', 'N4', 'salad');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('騒ぐ', 'さわぐ', 'N4', 'to make noise');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('触る', 'さわる', 'N4', 'to touch');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('産業', 'さんぎょう', 'N4', 'industry');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('サンダル', 'サンダル', 'N4', 'sandals');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('サンドイッチ', 'サンドイッチ', 'N4', 'sandwich');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('残念', 'ざんねん', 'N4', 'regrettable / too bad');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('市', 'し', 'N4', 'city');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('字', 'じ', 'N4', 'character / letter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('試合', 'しあい', 'N4', 'match / game');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('仕方', 'しかた', 'N4', 'way / method');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('しかる', 'しかる', 'N4', 'to scold');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('試験', 'しけん', 'N4', 'exam / test');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('事故', 'じこ', 'N4', 'accident');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('地震', 'じしん', 'N4', 'earthquake');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('時代', 'じだい', 'N4', 'era / period');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('下着', 'したぎ', 'N4', 'underwear');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('支度', 'したく', 'N4', 'preparation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('しっかり', 'しっかり', 'N4', 'firmly / properly');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('失敗', 'しっぱい', 'N4', 'failure');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('辞典', 'じてん', 'N4', 'dictionary');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('品物', 'しなもの', 'N4', 'goods / article');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('しばらく', 'しばらく', 'N4', 'for a while');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('島', 'しま', 'N4', 'island');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('市民', 'しみん', 'N4', 'citizen');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('事務所', 'じむしょ', 'N4', 'office');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('社会', 'しゃかい', 'N4', 'society');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('社長', 'しゃちょう', 'N4', 'company president');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('じゃま', 'じゃま', 'N4', 'obstacle / disturbance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ジャム', 'ジャム', 'N4', 'jam');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('自由', 'じゆう', 'N4', 'freedom');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('習慣', 'しゅうかん', 'N4', 'habit / custom');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('住所', 'じゅうしょ', 'N4', 'address');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('柔道', 'じゅうどう', 'N4', 'judo');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('十分', 'じゅうぶん', 'N4', 'enough / sufficient');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('出席', 'しゅっせき', 'N4', 'attendance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('出発', 'しゅっぱつ', 'N4', 'departure');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('趣味', 'しゅみ', 'N4', 'hobby');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('準備', 'じゅんび', 'N4', 'preparation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('紹介', 'しょうかい', 'N4', 'introduction');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('小学校', 'しょうがっこう', 'N4', 'elementary school');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('小説', 'しょうせつ', 'N4', 'novel');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('招待', 'しょうたい', 'N4', 'invitation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('承知', 'しょうち', 'N4', 'knowledge / consent');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('将来', 'しょうらい', 'N4', 'future');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('食事', 'しょくじ', 'N4', 'meal');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('食料品', 'しょくりょうひん', 'N4', 'groceries');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('女性', 'じょせい', 'N4', 'female / woman');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('知らせる', 'しらせる', 'N4', 'to notify');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('調べる', 'しらべる', 'N4', 'to investigate');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('人口', 'じんこう', 'N4', 'population');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('神社', 'じんじゃ', 'N4', 'Shinto shrine');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('親切', 'しんせつ', 'N4', 'kind / helpful');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('心配', 'しんぱい', 'N4', 'worry / concern');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('新聞社', 'しんぶんしゃ', 'N4', 'newspaper company');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('水泳', 'すいえい', 'N4', 'swimming');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('水道', 'すいどう', 'N4', 'water supply / tap water');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ずいぶん', 'ずいぶん', 'N4', 'very / quite');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('数学', 'すうがく', 'N4', 'mathematics');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('スーツ', 'スーツ', 'N4', 'suit');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('スーツケース', 'スーツケース', 'N4', 'suitcase');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('過ぎる', 'すぎる', 'N4', 'to pass / to exceed');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('すく', 'すく', 'N4', 'to be empty / to become less');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('スクリーン', 'スクリーン', 'N4', 'screen');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('凄い', 'すごい', 'N4', 'amazing / terrible');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('進む', 'すすむ', 'N4', 'to advance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('すっかり', 'すっかり', 'N4', 'completely / all');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('すっと', 'すっと', 'N4', 'smoothly / straight');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ステーキ', 'ステーキ', 'N4', 'steak');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('捨てる', 'すてる', 'N4', 'to throw away');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ステレオ', 'ステレオ', 'N4', 'stereo');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('砂', 'すな', 'N4', 'sand');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('すばらしい', 'すばらしい', 'N4', 'wonderful');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('滑る', 'すべる', 'N4', 'to slide / to slip');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('隅', 'すみ', 'N4', 'corner');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('済む', 'すむ', 'N4', 'to finish / to be done');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('すり', 'すり', 'N4', 'pickpocket');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('すると', 'すると', 'N4', 'then / thereupon');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('生活', 'せいかつ', 'N4', 'life / living');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('生産', 'せいさん', 'N4', 'production');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('政治', 'せいじ', 'N4', 'politics');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('西洋', 'せいよう', 'N4', 'Western world');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('世界', 'せかい', 'N4', 'world');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('席', 'せき', 'N4', 'seat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('説明', 'せつめい', 'N4', 'explanation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('背中', 'せなか', 'N4', 'back (body part)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ぜひ', 'ぜひ', 'N4', 'by all means / certainly');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('世話', 'せわ', 'N4', 'care / help');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('線', 'せん', 'N4', 'line');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ぜんぜん', 'ぜんぜん', 'N4', 'not at all (with negative)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('戦争', 'せんそう', 'N4', 'war');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('先輩', 'せんぱい', 'N4', 'senior / elder');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そう', 'そう', 'N4', 'so / like that / yes');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('相談', 'そうだん', 'N4', 'consultation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('育てる', 'そだてる', 'N4', 'to raise / to bring up');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('卒業', 'そつぎょう', 'N4', 'graduation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('祖父', 'そふ', 'N4', 'grandfather');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ソフト', 'ソフト', 'N4', 'soft');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('祖母', 'そぼ', 'N4', 'grandmother');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('それで', 'それで', 'N4', 'therefore / and then');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('それに', 'それに', 'N4', 'besides / moreover');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('それほど', 'それほど', 'N4', 'so much / to that extent');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そろそろ', 'そろそろ', 'N4', 'gradually / soon');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そんな', 'そんな', 'N4', 'such / that kind of');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そんなに', 'そんなに', 'N4', 'so / so much');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('退院', 'たいいん', 'N4', 'discharge from hospital');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大学生', 'だいがくせい', 'N4', 'college student');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大事', 'だいじ', 'N4', 'important / precious');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大体', 'だいたい', 'N4', 'roughly / mostly');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('たいてい', 'たいてい', 'N4', 'usually / generally');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('タイプ', 'タイプ', 'N4', 'type');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大分', 'だいぶ', 'N4', 'considerably');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('台風', 'たいふう', 'N4', 'typhoon');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('倒れる', 'たおれる', 'N4', 'to fall / to collapse');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('だから', 'だから', 'N4', 'therefore / so');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('確か', 'たしか', 'N4', 'sure / certain');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('足す', 'たす', 'N4', 'to add');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('訪ねる', 'たずねる', 'N4', 'to visit / to call on');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('尋ねる', 'たずねる', 'N4', 'to ask / to inquire');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('正しい', 'ただしい', 'N4', 'correct / right');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('畳', 'たたみ', 'N4', 'tatami mat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('立てる', 'たてる', 'N4', 'to stand / to set up');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('建てる', 'たてる', 'N4', 'to build');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('例えば', 'たとえば', 'N4', 'for example');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('棚', 'たな', 'N4', 'shelf');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('楽しみ', 'たのしみ', 'N4', 'enjoyment / pleasure');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('楽む', 'たのしむ', 'N4', 'to enjoy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('たまに', 'たまに', 'N4', 'occasionally');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('為', 'ため', 'N4', 'for the sake of / because');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('だめ', 'だめ', 'N4', 'no good / useless');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('足りる', 'たりる', 'N4', 'to be sufficient');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('男性', 'だんせい', 'N4', 'male');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('暖房', 'だんぼう', 'N4', 'heating');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('血', 'ち', 'N4', 'blood');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('チェック', 'チェック', 'N4', 'check');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('力', 'ちから', 'N4', 'strength / power');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ちっとも', 'ちっとも', 'N4', 'not at all (with negative)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ちゃん', 'ちゃん', 'N4', 'suffix for names (endearing)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('注意', 'ちゅうい', 'N4', 'attention / caution');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('中学校', 'ちゅうがっこう', 'N4', 'junior high school');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('注射', 'ちゅうしゃ', 'N4', 'injection');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('駐車場', 'ちゅうしゃじょう', 'N4', 'parking lot');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('地理', 'ちり', 'N4', 'geography');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('捕まえる', 'つかまえる', 'N4', 'to catch / to seize');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('つき', 'つき', 'N4', 'moon / month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('付く', 'つく', 'N4', 'to be attached / to follow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('漬ける', 'つける', 'N4', 'to pickle / to soak');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('都合', 'つごう', 'N4', 'circumstances / convenience');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('伝える', 'つたえる', 'N4', 'to convey / to report');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('続く', 'つづく', 'N4', 'to continue');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('続ける', 'つづける', 'N4', 'to continue (transitive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('包む', 'つつむ', 'N4', 'to wrap');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('妻', 'つま', 'N4', 'wife');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('つもり', 'つもり', 'N4', 'intention / plan');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('釣る', 'つる', 'N4', 'to fish / to angle');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('連れる', 'つれる', 'N4', 'to bring / to take (someone)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('丁寧', 'ていねい', 'N4', 'polite / courteous');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('テキスト', 'テキスト', 'N4', 'textbook');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('適当', 'てきとう', 'N4', 'suitable / appropriate');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('できるだけ', 'できるだけ', 'N4', 'as much as possible');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('手伝う', 'てつだう', 'N4', 'to help / to assist');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('テニス', 'テニス', 'N4', 'tennis');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('手袋', 'てぶくろ', 'N4', 'gloves');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('寺', 'てら', 'N4', 'Buddhist temple');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('点', 'てん', 'N4', 'point / dot');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('店員', 'てんいん', 'N4', 'clerk / shop assistant');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('天気予報', 'てんきよほう', 'N4', 'weather forecast');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('電灯', 'でんとう', 'N4', 'electric light');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('電報', 'でんぽう', 'N4', 'telegram');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('展覧会', 'てんらんかい', 'N4', 'exhibition');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('都', 'と', 'N4', 'metropolis / capital');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('道具', 'どうぐ', 'N4', 'tool / instrument');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('とうとう', 'とうとう', 'N4', 'finally / eventually');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('動物園', 'どうぶつえん', 'N4', 'zoo');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('遠く', 'とおく', 'N4', 'far away / distance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('通る', 'とおる', 'N4', 'to go through / to pass');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('特に', 'とくに', 'N4', 'especially');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('特別', 'とくべつ', 'N4', 'special');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('とこや', 'とこや', 'N4', 'barbershop');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('途中', 'とちゅう', 'N4', 'on the way / midway');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('特急', 'とっきゅう', 'N4', 'limited express (train)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('届ける', 'とどける', 'N4', 'to deliver');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('泊まる', 'とまる', 'N4', 'to stay (overnight)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('止める', 'とめる', 'N4', 'to stop (transitive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('取り替える', 'とりかえる', 'N4', 'to exchange / to replace');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('泥棒', 'どろぼう', 'N4', 'thief');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どんどん', 'どんどん', 'N4', 'rapidly / continuously');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('直す', 'なおす', 'N4', 'to fix / to cure');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('直る', 'なおる', 'N4', 'to be fixed / to be cured');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('治る', 'なおる', 'N4', 'to be cured / to heal');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('中々', 'なかなか', 'N4', 'quite / very (also with negative: not easily)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('泣く', 'なく', 'N4', 'to cry');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('無くなる', 'なくなる', 'N4', 'to be lost / to disappear');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('亡くなる', 'なくなる', 'N4', 'to die');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('投げる', 'なげる', 'N4', 'to throw');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('なさる', 'なさる', 'N4', 'to do (honorific)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('鳴る', 'なる', 'N4', 'to ring / to sound');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('なるべく', 'なるべく', 'N4', 'as far as possible');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('なるほど', 'なるほど', 'N4', 'indeed / I see');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('慣れる', 'なれる', 'N4', 'to get used to');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('におい', 'におい', 'N4', 'smell / odor');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('苦い', 'にがい', 'N4', 'bitter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('二階建て', 'にかいだて', 'N4', 'two-story building');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('逃げる', 'にげる', 'N4', 'to escape');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('日記', 'にっき', 'N4', 'diary');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('入院', 'にゅういん', 'N4', 'hospitalization');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('入学', 'にゅうがく', 'N4', 'school admission');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('似る', 'にる', 'N4', 'to resemble');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('人形', 'にんぎょう', 'N4', 'doll');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('盗む', 'ぬすむ', 'N4', 'to steal');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('塗る', 'ぬる', 'N4', 'to paint / to apply');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ぬれる', 'ぬれる', 'N4', 'to get wet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ねだん', 'ねだん', 'N4', 'price');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('熱', 'ねつ', 'N4', 'fever / heat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ねっしん', 'ねっしん', 'N4', 'enthusiasm / zeal');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('寝坊', 'ねぼう', 'N4', 'oversleeping');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('眠い', 'ねむい', 'N4', 'sleepy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('眠る', 'ねむる', 'N4', 'to sleep');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('残る', 'のこる', 'N4', 'to remain / to be left');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('のど', 'のど', 'N4', 'throat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('乗り換える', 'のりかえる', 'N4', 'to transfer (trains)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('乗り物', 'のりもの', 'N4', 'vehicle');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('葉', 'は', 'N4', 'leaf');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('場合', 'ばあい', 'N4', 'case / situation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('パート', 'パート', 'N4', 'part-time');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('倍', 'ばい', 'N4', 'double / times');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('拝見', 'はいけん', 'N4', '(humble) to see / to look');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('歯医者', 'はいしゃ', 'N4', 'dentist');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('運ぶ', 'はこぶ', 'N4', 'to carry / to transport');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('始める', 'はじめる', 'N4', 'to begin (transitive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('場所', 'ばしょ', 'N4', 'place / location');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('はず', 'はず', 'N4', 'expectation / should be');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('恥ずかしい', 'はずかしい', 'N4', 'embarrassed / shy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('パソコン', 'パソコン', 'N4', 'personal computer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('発音', 'はつおん', 'N4', 'pronunciation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('はっきり', 'はっきり', 'N4', 'clearly / distinctly');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('花見', 'はなみ', 'N4', 'cherry blossom viewing');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('林', 'はやし', 'N4', 'grove / forest');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('払う', 'はらう', 'N4', 'to pay');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('番組', 'ばんぐみ', 'N4', 'TV program');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('反対', 'はんたい', 'N4', 'opposite / opposition');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ハンドバッグ', 'ハンドバッグ', 'N4', 'handbag');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('日', 'ひ', 'N4', 'day / sun');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('火', 'ひ', 'N4', 'fire');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ピアノ', 'ピアノ', 'N4', 'piano');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('冷える', 'ひえる', 'N4', 'to grow cold');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('光', 'ひかり', 'N4', 'light');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('光る', 'ひかる', 'N4', 'to shine');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('引き出し', 'ひきだし', 'N4', 'drawer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('引き出す', 'ひきだす', 'N4', 'to pull out');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ひげ', 'ひげ', 'N4', 'beard / mustache');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('飛行場', 'ひこうじょう', 'N4', 'airport');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('久しぶり', 'ひさしぶり', 'N4', 'after a long time');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('美術館', 'びじゅつかん', 'N4', 'art museum');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('非常に', 'ひじょうに', 'N4', 'extremely / very');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('びっくり', 'びっくり', 'N4', 'to be surprised');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('引っ越す', 'ひっこす', 'N4', 'to move (house)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('必要', 'ひつよう', 'N4', 'necessary');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ひどい', 'ひどい', 'N4', 'terrible / severe');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('開く', 'ひらく', 'N4', 'to open');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ビル', 'ビル', 'N4', 'building');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('昼間', 'ひるま', 'N4', 'daytime');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('昼休み', 'ひるやすみ', 'N4', 'lunch break');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('拾う', 'ひろう', 'N4', 'to pick up');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ファックス', 'ファックス', 'N4', 'fax');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('増える', 'ふえる', 'N4', 'to increase');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('深い', 'ふかい', 'N4', 'deep');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('複雑', 'ふくざつ', 'N4', 'complex / complicated');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('復習', 'ふくしゅう', 'N4', 'review (study)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('部長', 'ぶちょう', 'N4', 'section chief');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('普通', 'ふつう', 'N4', 'normal / ordinary');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ぶどう', 'ぶどう', 'N4', 'grape');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('太る', 'ふとる', 'N4', 'to become fat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('布団', 'ふとん', 'N4', 'futon / bedding');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('舟', 'ふね', 'N4', 'boat / ship');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('不便', 'ふべん', 'N4', 'inconvenient');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('踏む', 'ふむ', 'N4', 'to step on');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('降り出す', 'ふりだす', 'N4', 'to start raining');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('プレゼント', 'プレゼント', 'N4', 'gift / present');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('文化', 'ぶんか', 'N4', 'culture');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('文学', 'ぶんがく', 'N4', 'literature');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('文法', 'ぶんぽう', 'N4', 'grammar');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('別', 'べつ', 'N4', 'separate / different');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ベル', 'ベル', 'N4', 'bell');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('変', 'へん', 'N4', 'strange / odd');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('返事', 'へんじ', 'N4', 'reply / answer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('貿易', 'ぼうえき', 'N4', 'trade / commerce');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('放送', 'ほうそう', 'N4', 'broadcast');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('法律', 'ほうりつ', 'N4', 'law');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('僕', 'ぼく', 'N4', 'I (male)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('星', 'ほし', 'N4', 'star');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ほど', 'ほど', 'N4', 'degree / extent');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ほとんど', 'ほとんど', 'N4', 'almost / mostly');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ほめる', 'ほめる', 'N4', 'to praise');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('翻訳', 'ほんやく', 'N4', 'translation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('参る', 'まいる', 'N4', 'to go / to come (humble)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('負ける', 'まける', 'N4', 'to lose (a game)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('まじめ', 'まじめ', 'N4', 'serious / diligent');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('まず', 'まず', 'N4', 'first of all');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('または', 'または', 'N4', 'or');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('間違える', 'まちがえる', 'N4', 'to make a mistake');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('間に合う', 'まにあう', 'N4', 'to be in time');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('周り', 'まわり', 'N4', 'surroundings / circumference');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('回る', 'まわる', 'N4', 'to go around');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('漫画', 'まんが', 'N4', 'comic / manga');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('真中', 'まんなか', 'N4', 'center / middle');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('見える', 'みえる', 'N4', 'to be visible');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('湖', 'みずうみ', 'N4', 'lake');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('味噌', 'みそ', 'N4', 'miso (fermented soybean paste)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('見つかる', 'みつかる', 'N4', 'to be found');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('見つける', 'みつける', 'N4', 'to find');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('皆', 'みな', 'N4', 'everyone');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('港', 'みなと', 'N4', 'port / harbor');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('向かう', 'むかう', 'N4', 'to face / to go toward');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('迎える', 'むかえる', 'N4', 'to welcome / to meet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('昔', 'むかし', 'N4', 'olden times / the past');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('虫', 'むし', 'N4', 'insect / bug');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('息子', 'むすこ', 'N4', 'son');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('娘', 'むすめ', 'N4', 'daughter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('無理', 'むり', 'N4', 'impossible / unreasonable');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('召し上がる', 'めしあがる', 'N4', 'to eat / to drink (honorific)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('珍しい', 'めずらしい', 'N4', 'rare / unusual');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('申し上げる', 'もうしあげる', 'N4', 'to say / to state (humble)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('申す', 'もうす', 'N4', 'to say (humble)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('もうすぐ', 'もうすぐ', 'N4', 'very soon');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('もし', 'もし', 'N4', 'if');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('もちろん', 'もちろん', 'N4', 'of course');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('もっとも', 'もっとも', 'N4', 'most / extremely');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('戻る', 'もどる', 'N4', 'to return / to go back');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('木綿', 'もめん', 'N4', 'cotton');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('もらう', 'もらう', 'N4', 'to receive');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('森', 'もり', 'N4', 'forest');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('焼く', 'やく', 'N4', 'to bake / to burn');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('約束', 'やくそく', 'N4', 'promise');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('役に立つ', 'やくにたつ', 'N4', 'to be useful');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('焼ける', 'やける', 'N4', 'to be baked / to burn');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('優しい', 'やさしい', 'N4', 'kind / gentle');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('痩せる', 'やせる', 'N4', 'to lose weight');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('やっと', 'やっと', 'N4', 'finally / at last');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('やはり', 'やはり', 'N4', 'also / as expected');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('やっぱり', 'やっぱり', 'N4', 'also / as expected (coll.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('止む', 'やむ', 'N4', 'to stop (rain etc.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('止める', 'やめる', 'N4', 'to quit / to stop');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('柔らかい', 'やわらかい', 'N4', 'soft / tender');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('湯', 'ゆ', 'N4', 'hot water');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('輸出', 'ゆしゅつ', 'N4', 'export');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('輸入', 'ゆにゅう', 'N4', 'import');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('指', 'ゆび', 'N4', 'finger / toe');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('指輪', 'ゆびわ', 'N4', 'ring (jewelry)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('夢', 'ゆめ', 'N4', 'dream');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('揺れる', 'ゆれる', 'N4', 'to shake / to sway');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('用', 'よう', 'N4', 'use / business');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('用意', 'ようい', 'N4', 'preparation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('用事', 'ようじ', 'N4', 'errand / business');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('汚れる', 'よごれる', 'N4', 'to get dirty');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('予習', 'よしゅう', 'N4', 'preparation (for a lesson)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('予定', 'よてい', 'N4', 'schedule / plan');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('予約', 'よやく', 'N4', 'reservation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('寄る', 'よる', 'N4', 'to drop by / to visit');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('喜ぶ', 'よろこぶ', 'N4', 'to be delighted');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('よろしい', 'よろしい', 'N4', 'good / all right (polite)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('理由', 'りゆう', 'N4', 'reason');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('利用', 'りよう', 'N4', 'use / utilization');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('両方', 'りょうほう', 'N4', 'both sides / both');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('旅館', 'りょかん', 'N4', 'Japanese inn');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('留守', 'るす', 'N4', 'absence / away from home');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('冷房', 'れいぼう', 'N4', 'air conditioning');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('歴史', 'れきし', 'N4', 'history');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('レジ', 'レジ', 'N4', 'cash register');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('レポート', 'レポート', 'N4', 'report');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('リポート', 'リポート', 'N4', 'report');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('連絡', 'れんらく', 'N4', 'contact / communication');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ワープロ', 'ワープロ', 'N4', 'word processor');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('沸かす', 'わかす', 'N4', 'to boil (water)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('別れる', 'わかれる', 'N4', 'to part / to separate');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('沸く', 'わく', 'N4', 'to boil / to be excited');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('訳', 'わけ', 'N4', 'meaning / reason');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('忘れ物', 'わすれもの', 'N4', 'lost item');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('笑う', 'わらう', 'N4', 'to laugh');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('割合', 'わりあい', 'N4', 'percentage / proportion');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('割れる', 'われる', 'N4', 'to break / to split');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('泳ぎ方', 'およぎかた', 'N4', 'way of swimming');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('会う', 'あう', 'N5', 'to meet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('青', 'あお', 'N5', 'blue');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('青い', 'あおい', 'N5', 'blue');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('赤', 'あか', 'N5', 'red');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('赤い', 'あかい', 'N5', 'red');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('明い', 'あかるい', 'N5', 'bright / light');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('秋', 'あき', 'N5', 'autumn');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('開く', 'あく', 'N5', 'to open (intransitive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('開ける', 'あける', 'N5', 'to open (transitive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('上げる', 'あげる', 'N5', 'to raise');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('朝', 'あさ', 'N5', 'morning');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('朝御飯', 'あさごはん', 'N5', 'breakfast');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あさって', 'あさって', 'N5', 'day after tomorrow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('足', 'あし', 'N5', 'foot / leg');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('明日', 'あした', 'N5', 'tomorrow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あそこ', 'あそこ', 'N5', 'over there');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('遊ぶ', 'あそぶ', 'N5', 'to play');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('暖かい', 'あたたかい', 'N5', 'warm');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('頭', 'あたま', 'N5', 'head');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('新しい', 'あたらしい', 'N5', 'new');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あちら', 'あちら', 'N5', 'that way / over there');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('暑い', 'あつい', 'N5', 'hot (weather)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('熱い', 'あつい', 'N5', 'hot (to touch)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('厚い', 'あつい', 'N5', 'thick');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あっち', 'あっち', 'N5', 'that way (coll.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('後', 'あと', 'N5', 'after / later / rear');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あなた', 'あなた', 'N5', 'you');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('兄', 'あに', 'N5', 'older brother');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('姉', 'あね', 'N5', 'older sister');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あの', 'あの', 'N5', 'that (over there)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('アパート', 'アパート', 'N5', 'apartment');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あびる', 'あびる', 'N5', 'to bathe / to shower');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('危ない', 'あぶない', 'N5', 'dangerous');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('甘い', 'あまい', 'N5', 'sweet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あまり', 'あまり', 'N5', 'not very (with negative) / too much');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('雨', 'あめ', 'N5', 'rain');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('飴', 'あめ', 'N5', 'candy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('洗う', 'あらう', 'N5', 'to wash');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ある', 'ある', 'N5', 'to exist (inanimate) / to have');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('歩く', 'あるく', 'N5', 'to walk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('あれ', 'あれ', 'N5', 'that over there');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いい', 'いい', 'N5', 'good');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('よい', 'よい', 'N5', 'good');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いいえ', 'いいえ', 'N5', 'no');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('言う', 'いう', 'N5', 'to say');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('家', 'いえ', 'N5', 'house');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いかが', 'いかが', 'N5', 'how (polite)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('行く', 'いく', 'N5', 'to go');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いくつ', 'いくつ', 'N5', 'how many / how old');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いくら', 'いくら', 'N5', 'how much');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('池', 'いけ', 'N5', 'pond');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('医者', 'いしゃ', 'N5', 'doctor');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いす', 'いす', 'N5', 'chair');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('忙しい', 'いそがしい', 'N5', 'busy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('痛い', 'いたい', 'N5', 'painful');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一', 'いち', 'N5', 'one');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一日', 'いちにち', 'N5', 'one day');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いちばん', 'いちばん', 'N5', 'number one / best');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いつ', 'いつ', 'N5', 'when');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('五日', 'いつか', 'N5', 'fifth day / five days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一緒', 'いっしょ', 'N5', 'together');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('五つ', 'いつつ', 'N5', 'five (things)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いつも', 'いつも', 'N5', 'always');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('犬', 'いぬ', 'N5', 'dog');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今', 'いま', 'N5', 'now');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('意味', 'いみ', 'N5', 'meaning');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('妹', 'いもうと', 'N5', 'younger sister');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('嫌', 'いや', 'N5', 'disagreeable / unpleasant');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('入口', 'いりぐち', 'N5', 'entrance');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('居る', 'いる', 'N5', 'to be (animate)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('要る', 'いる', 'N5', 'to need');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('入れる', 'いれる', 'N5', 'to put in');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('色', 'いろ', 'N5', 'color');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('いろいろ', 'いろいろ', 'N5', 'various');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('上', 'うえ', 'N5', 'above / top');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('後ろ', 'うしろ', 'N5', 'back / behind');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('薄い', 'うすい', 'N5', 'thin / pale');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('歌', 'うた', 'N5', 'song');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('歌う', 'うたう', 'N5', 'to sing');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('生まれる', 'うまれる', 'N5', 'to be born');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('海', 'うみ', 'N5', 'sea / ocean');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('売る', 'うる', 'N5', 'to sell');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('煩い', 'うるさい', 'N5', 'noisy / annoying');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('上着', 'うわぎ', 'N5', 'jacket / coat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('絵', 'え', 'N5', 'picture / drawing');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('映画', 'えいが', 'N5', 'movie');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('映画館', 'えいがかん', 'N5', 'movie theater');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('英語', 'えいご', 'N5', 'English language');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ええ', 'ええ', 'N5', 'yes (coll.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('駅', 'えき', 'N5', 'station');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('エレベーター', 'エレベーター', 'N5', 'elevator');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('鉛筆', 'えんぴつ', 'N5', 'pencil');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おいしい', 'おいしい', 'N5', 'delicious');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('多い', 'おおい', 'N5', 'many / much');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大きい', 'おおきい', 'N5', 'big / large');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大きな', 'おおきな', 'N5', 'big (attributive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大勢', 'おおぜい', 'N5', 'crowd / many people');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お母さん', 'おかあさん', 'N5', 'mother');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お菓子', 'おかし', 'N5', 'sweets / candy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お金', 'おかね', 'N5', 'money');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('起きる', 'おきる', 'N5', 'to wake up / to happen');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('置く', 'おく', 'N5', 'to put / to place');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('奥さん', 'おくさん', 'N5', 'wife (someone else''s)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お酒', 'おさけ', 'N5', 'sake / alcohol');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お皿', 'おさら', 'N5', 'plate / dish');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('伯父', 'おじいさん', 'N5', 'grandfather (also 祖父)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('叔父', 'おじいさん', 'N5', 'grandfather');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('教える', 'おしえる', 'N5', 'to teach / to tell');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('伯父', 'おじさん', 'N5', 'uncle (older)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('叔父', 'おじさん', 'N5', 'uncle (younger)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('押す', 'おす', 'N5', 'to push');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('遅い', 'おそい', 'N5', 'slow / late');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お茶', 'おちゃ', 'N5', 'tea');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お手洗い', 'おてあらい', 'N5', 'toilet / restroom');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お父さん', 'おとうさん', 'N5', 'father');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('弟', 'おとうと', 'N5', 'younger brother');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('男', 'おとこ', 'N5', 'man');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('男の子', 'おとこのこ', 'N5', 'boy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一昨日', 'おととい', 'N5', 'day before yesterday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一昨年', 'おととし', 'N5', 'year before last');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大人', 'おとな', 'N5', 'adult');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おなか', 'おなか', 'N5', 'stomach');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('同じ', 'おなじ', 'N5', 'same');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お兄さん', 'おにいさん', 'N5', 'older brother');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お姉さん', 'おねえさん', 'N5', 'older sister');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おばあさん', 'おばあさん', 'N5', 'grandmother');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('伯母さん', 'おばさん', 'N5', 'aunt (older)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('叔母さん', 'おばさん', 'N5', 'aunt (younger)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お風呂', 'おふろ', 'N5', 'bath');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('お弁当', 'おべんとう', 'N5', 'boxed lunch');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('覚える', 'おぼえる', 'N5', 'to memorize');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おまわりさん', 'おまわりさん', 'N5', 'police officer (coll.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('重い', 'おもい', 'N5', 'heavy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('おもしろい', 'おもしろい', 'N5', 'interesting / funny');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('泳ぐ', 'およぐ', 'N5', 'to swim');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('降りる', 'おりる', 'N5', 'to get off / to descend');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('終る', 'おわる', 'N5', 'to end / to finish');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('音楽', 'おんがく', 'N5', 'music');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('女', 'おんな', 'N5', 'woman');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('女の子', 'おんなのこ', 'N5', 'girl');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('外国', 'がいこく', 'N5', 'foreign country');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('外国人', 'がいこくじん', 'N5', 'foreigner');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('会社', 'かいしゃ', 'N5', 'company');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('階段', 'かいだん', 'N5', 'stairs');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('買い物', 'かいもの', 'N5', 'shopping');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('買う', 'かう', 'N5', 'to buy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('返す', 'かえす', 'N5', 'to return (something)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('帰る', 'かえる', 'N5', 'to go back / to return');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('かかる', 'かかる', 'N5', 'to take (time/money) / to hang');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('かぎ', 'かぎ', 'N5', 'key');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('書く', 'かく', 'N5', 'to write');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('学生', 'がくせい', 'N5', 'student');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('かける', 'かける', 'N5', 'to hang / to put on (glasses)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('傘', 'かさ', 'N5', 'umbrella');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('貸す', 'かす', 'N5', 'to lend');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('風', 'かぜ', 'N5', 'wind / cold (illness)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('風邪', 'かぜ', 'N5', 'cold (illness)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('家族', 'かぞく', 'N5', 'family');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('方', 'かた', 'N5', 'way / person (polite)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('学校', 'がっこう', 'N5', 'school');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('カップ', 'カップ', 'N5', 'cup');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('家庭', 'かてい', 'N5', 'household / home');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('角', 'かど', 'N5', 'corner');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('かばん', 'かばん', 'N5', 'bag');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('花瓶', 'かびん', 'N5', 'vase');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('紙', 'かみ', 'N5', 'paper');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('カメラ', 'カメラ', 'N5', 'camera');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('火曜日', 'かようび', 'N5', 'Tuesday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('辛い', 'からい', 'N5', 'spicy / hot (taste)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('体', 'からだ', 'N5', 'body');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('借りる', 'かりる', 'N5', 'to borrow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('軽い', 'かるい', 'N5', 'light (weight)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('カレー', 'カレー', 'N5', 'curry');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('カレンダー', 'カレンダー', 'N5', 'calendar');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('川', 'かわ', 'N5', 'river');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('河', 'かわ', 'N5', 'river');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('かわいい', 'かわいい', 'N5', 'cute / adorable');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('漢字', 'かんじ', 'N5', 'Kanji (Chinese characters)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('木', 'き', 'N5', 'tree / wood');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('黄色', 'きいろ', 'N5', 'yellow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('黄色い', 'きいろい', 'N5', 'yellow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('消える', 'きえる', 'N5', 'to disappear / to go out');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('聞く', 'きく', 'N5', 'to listen / to ask');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('北', 'きた', 'N5', 'north');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ギター', 'ギター', 'N5', 'guitar');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('汚い', 'きたない', 'N5', 'dirty');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('喫茶店', 'きっさてん', 'N5', 'coffee shop / cafe');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('切手', 'きって', 'N5', 'postage stamp');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('切符', 'きっぷ', 'N5', 'ticket');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('昨日', 'きのう', 'N5', 'yesterday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('九', 'きゅう', 'N5', 'nine');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('九', 'く', 'N5', 'nine');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('牛肉', 'ぎゅうにく', 'N5', 'beef');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('牛乳', 'ぎゅうにゅう', 'N5', 'milk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今日', 'きょう', 'N5', 'today');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('教室', 'きょうしつ', 'N5', 'classroom');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('兄弟', 'きょうだい', 'N5', 'brothers and sisters');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('去年', 'きょねん', 'N5', 'last year');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('嫌い', 'きらい', 'N5', 'dislike / hatred');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('切る', 'きる', 'N5', 'to cut');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('着る', 'きる', 'N5', 'to wear');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('きれい', 'きれい', 'N5', 'pretty / clean');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('キロ', 'キロ', 'N5', 'kilo (kilogram/kilometer)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('キログラム', 'キログラム', 'N5', 'kilogram');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('キロメートル', 'キロメートル', 'N5', 'kilometer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('銀行', 'ぎんこう', 'N5', 'bank');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('金曜日', 'きんようび', 'N5', 'Friday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('薬', 'くすり', 'N5', 'medicine');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ください', 'ください', 'N5', 'please give me');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('果物', 'くだもの', 'N5', 'fruit');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('口', 'くち', 'N5', 'mouth');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('靴', 'くつ', 'N5', 'shoes');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('靴下', 'くつした', 'N5', 'socks');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('国', 'くに', 'N5', 'country');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('曇り', 'くもり', 'N5', 'cloudy weather');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('曇る', 'くもる', 'N5', 'to become cloudy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('暗い', 'くらい', 'N5', 'dark');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('クラス', 'クラス', 'N5', 'class (school)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('グラム', 'グラム', 'N5', 'gram');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('来る', 'くる', 'N5', 'to come');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('車', 'くるま', 'N5', 'car');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('黒', 'くろ', 'N5', 'black');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('黒い', 'くろい', 'N5', 'black');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('警官', 'けいかん', 'N5', 'police officer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今朝', 'けさ', 'N5', 'this morning');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('消す', 'けす', 'N5', 'to erase / to turn off');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('結構', 'けっこう', 'N5', 'fine / splendid / enough');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('結婚', 'けっこん', 'N5', 'marriage');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('月曜日', 'げつようび', 'N5', 'Monday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('玄関', 'げんかん', 'N5', 'entrance hall / front door');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('元気', 'げんき', 'N5', 'healthy / energetic');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('五', 'ご', 'N5', 'five');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('公園', 'こうえん', 'N5', 'park');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('交差点', 'こうさてん', 'N5', 'intersection');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('紅茶', 'こうちゃ', 'N5', 'black tea');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('交番', 'こうばん', 'N5', 'police box');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('声', 'こえ', 'N5', 'voice');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('コート', 'コート', 'N5', 'coat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('コーヒー', 'コーヒー', 'N5', 'coffee');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ここ', 'ここ', 'N5', 'here');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('午後', 'ごご', 'N5', 'afternoon');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('九日', 'ここのか', 'N5', 'ninth day of month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('九つ', 'ここのつ', 'N5', 'nine (things)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('午前', 'ごぜん', 'N5', 'morning / a.m.');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('答える', 'こたえる', 'N5', 'to answer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('こちら', 'こちら', 'N5', 'this way / this person');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('こっち', 'こっち', 'N5', 'this way (coll.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('コップ', 'コップ', 'N5', 'glass (cup)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今年', 'ことし', 'N5', 'this year');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('言葉', 'ことば', 'N5', 'word / language');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('子供', 'こども', 'N5', 'child');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('この', 'この', 'N5', 'this (before noun)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('御飯', 'ごはん', 'N5', 'meal / rice');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('コピーする', 'コピーする', 'N5', 'to copy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('困る', 'こまる', 'N5', 'to be troubled');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('これ', 'これ', 'N5', 'this');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今月', 'こんげつ', 'N5', 'this month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今週', 'こんしゅう', 'N5', 'this week');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('こんな', 'こんな', 'N5', 'this kind of');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('今晩', 'こんばん', 'N5', 'tonight');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('さあ', 'さあ', 'N5', 'come now / well');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('財布', 'さいふ', 'N5', 'wallet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('魚', 'さかな', 'N5', 'fish');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('先', 'さき', 'N5', 'ahead / previous');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('咲く', 'さく', 'N5', 'to bloom');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('作文', 'さくぶん', 'N5', 'composition / essay');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('差す', 'さす', 'N5', 'to shine (sun) / to raise (umbrella)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('雑誌', 'ざっし', 'N5', 'magazine');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('砂糖', 'さとう', 'N5', 'sugar');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('寒い', 'さむい', 'N5', 'cold (weather)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('さ来年', 'さらいねん', 'N5', 'year after next');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('三', 'さん', 'N5', 'three');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('散歩する', 'さんぽする', 'N5', 'to take a walk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('四', 'し', 'N5', 'four');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('四', 'よん', 'N5', 'four');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('塩', 'しお', 'N5', 'salt');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('しかし', 'しかし', 'N5', 'however');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('時間', 'じかん', 'N5', 'time / hour');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('仕事', 'しごと', 'N5', 'work / job');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('辞書', 'じしょ', 'N5', 'dictionary');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('静か', 'しずか', 'N5', 'quiet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('下', 'した', 'N5', 'below / under');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('七', 'しち', 'N5', 'seven');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('七', 'なな', 'N5', 'seven');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('質問', 'しつもん', 'N5', 'question');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('自転車', 'じてんしゃ', 'N5', 'bicycle');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('自動車', 'じどうしゃ', 'N5', 'car');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('死ぬ', 'しぬ', 'N5', 'to die');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('字引', 'じびき', 'N5', 'dictionary (less common)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('自分', 'じぶん', 'N5', 'oneself');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('閉まる', 'しまる', 'N5', 'to be closed');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('閉める', 'しめる', 'N5', 'to close');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('締める', 'しめる', 'N5', 'to tighten');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('じゃ', 'じゃ', 'N5', 'then / well (contraction of では)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('じゃあ', 'じゃあ', 'N5', 'then / well');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('写真', 'しゃしん', 'N5', 'photograph');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('シャツ', 'シャツ', 'N5', 'shirt');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('シャワー', 'シャワー', 'N5', 'shower');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('十', 'じゅう', 'N5', 'ten');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('十', 'とお', 'N5', 'ten');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('授業', 'じゅぎょう', 'N5', 'lesson / class');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('宿題', 'しゅくだい', 'N5', 'homework');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('上手', 'じょうず', 'N5', 'skillful / good at');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('丈夫', 'じょうぶ', 'N5', 'strong / healthy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('しょうゆ', 'しょうゆ', 'N5', 'soy sauce');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('食堂', 'しょくどう', 'N5', 'dining hall / cafeteria');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('知る', 'しる', 'N5', 'to know');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('白', 'しろ', 'N5', 'white');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('白い', 'しろい', 'N5', 'white');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('新聞', 'しんぶん', 'N5', 'newspaper');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('水曜日', 'すいようび', 'N5', 'Wednesday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('吸う', 'すう', 'N5', 'to inhale / to smoke');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('スカート', 'スカート', 'N5', 'skirt');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('好き', 'すき', 'N5', 'liking / fondness');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('少ない', 'すくない', 'N5', 'few / little');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('すぐに', 'すぐに', 'N5', 'immediately');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('少し', 'すこし', 'N5', 'a little');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('涼しい', 'すずしい', 'N5', 'cool (temperature)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ストーブ', 'ストーブ', 'N5', 'stove / heater');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('スプーン', 'スプーン', 'N5', 'spoon');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('スポーツ', 'スポーツ', 'N5', 'sports');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ズボン', 'ズボン', 'N5', 'trousers / pants');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('住む', 'すむ', 'N5', 'to live (reside)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('スリッパ', 'スリッパ', 'N5', 'slippers');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('する', 'する', 'N5', 'to do');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('座る', 'すわる', 'N5', 'to sit');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('背', 'せ', 'N5', 'height / back (body)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('生徒', 'せいと', 'N5', 'student (middle/high school)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('セーター', 'セーター', 'N5', 'sweater');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('せっけん', 'せっけん', 'N5', 'soap');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('背広', 'せびろ', 'N5', 'business suit');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('狭い', 'せまい', 'N5', 'narrow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ゼロ', 'ゼロ', 'N5', 'zero');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('千', 'せん', 'N5', 'thousand');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('先月', 'せんげつ', 'N5', 'last month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('先週', 'せんしゅう', 'N5', 'last week');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('先生', 'せんせい', 'N5', 'teacher');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('洗濯', 'せんたく', 'N5', 'laundry');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('全部', 'ぜんぶ', 'N5', 'all / whole');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('掃除する', 'そうじする', 'N5', 'to clean');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そうして', 'そうして', 'N5', 'and then / so');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そして', 'そして', 'N5', 'and then');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そこ', 'そこ', 'N5', 'there');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そちら', 'そちら', 'N5', 'that way');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そっち', 'そっち', 'N5', 'that way (coll.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('外', 'そと', 'N5', 'outside');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('その', 'その', 'N5', 'that (before noun)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('そば', 'そば', 'N5', 'side / near');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('空', 'そら', 'N5', 'sly');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('それ', 'それ', 'N5', 'that');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('それから', 'それから', 'N5', 'after that / and then');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('それでは', 'それでは', 'N5', 'well then');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大学', 'だいがく', 'N5', 'university');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大使館', 'たいしかん', 'N5', 'embassy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大丈夫', 'だいじょうぶ', 'N5', 'alright / safe');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大好き', 'だいすき', 'N5', 'like very much');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('大切', 'たいせつ', 'N5', 'important / precious');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('台所', 'だいどころ', 'N5', 'kitchen');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('たいへん', 'たいへん', 'N5', 'very / terribly / serious');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('高い', 'たかい', 'N5', 'high / expensive');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('たくさん', 'たくさん', 'N5', 'many / a lot');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('タクシー', 'タクシー', 'N5', 'taxi');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('出す', 'だす', 'N5', 'to take out / to produce');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('立つ', 'たつ', 'N5', 'to stand');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('たて', 'たて', 'N5', 'vertical / length (also 縦)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('建物', 'たてもの', 'N5', 'building');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('楽しい', 'たのしい', 'N5', 'enjoyable / fun');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('頼む', 'たのむ', 'N5', 'to request / to ask');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('たばこ', 'たばこ', 'N5', 'tobacco / cigarette');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('たぶん', 'たぶん', 'N5', 'probably');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('食べ物', 'たべもの', 'N5', 'food');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('食べる', 'たべる', 'N5', 'to eat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('卵', 'たまご', 'N5', 'egg');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('誰', 'だれ', 'N5', 'who');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('誰か', 'だれか', 'N5', 'someone');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('誕生日', 'たんじょうび', 'N5', 'birthday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('だんだん', 'だんだん', 'N5', 'gradually');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('小さい', 'ちいさい', 'N5', 'small / little');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('小さな', 'ちいさな', 'N5', 'small (attributive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('近い', 'ちかい', 'N5', 'near / close');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('違う', 'ちがう', 'N5', 'to differ / wrong');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('近く', 'ちかく', 'N5', 'nearby / vicinity');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('地下鉄', 'ちかてつ', 'N5', 'subway');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('地図', 'ちず', 'N5', 'map');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('茶色', 'ちゃいろ', 'N5', 'brown');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ちゃわん', 'ちゃわん', 'N5', 'rice bowl');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ちょうど', 'ちょうど', 'N5', 'exactly / just');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ちょっと', 'ちょっと', 'N5', 'a little / somewhat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一日', 'ついたち', 'N5', 'first day of month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('使う', 'つかう', 'N5', 'to use');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('疲れる', 'つかれる', 'N5', 'to get tired');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('次', 'つぎ', 'N5', 'next');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('着く', 'つく', 'N5', 'to arrive');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('机', 'つくえ', 'N5', 'desk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('作る', 'つくる', 'N5', 'to make / to create');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('つける', 'つける', 'N5', 'to attach / to turn on');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('勤める', 'つとめる', 'N5', 'to work for');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('つまらない', 'つまらない', 'N5', 'boring / trivial');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('冷たい', 'つめたい', 'N5', 'cold (to touch)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('強い', 'つよい', 'N5', 'strong');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('手', 'て', 'N5', 'hand');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('テープ', 'テープ', 'N5', 'tape');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('テーブル', 'テーブル', 'N5', 'table');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('テープレコーダー', 'テープレコーダー', 'N5', 'tape recorder');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('出かける', 'でかける', 'N5', 'to go out');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('手紙', 'てがみ', 'N5', 'letter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('できる', 'できる', 'N5', 'can / to be able');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('出口', 'でぐち', 'N5', 'exit');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('テスト', 'テスト', 'N5', 'test');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('では', 'では', 'N5', 'then / well');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('デパート', 'デパート', 'N5', 'department store');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('でも', 'でも', 'N5', 'but / however');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('出る', 'でる', 'N5', 'to go out / to leave');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('テレビ', 'テレビ', 'N5', 'TV');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('天気', 'てんき', 'N5', 'weather');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('電気', 'でんき', 'N5', 'electricity');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('電車', 'でんしゃ', 'N5', 'electric train');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('電話', 'でんわ', 'N5', 'telephone');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('戸', 'と', 'N5', 'door');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ドア', 'ドア', 'N5', 'door');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('トイレ', 'トイレ', 'N5', 'toilet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どう', 'どう', 'N5', 'how / in what way');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どうして', 'どうして', 'N5', 'why');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どうぞ', 'どうぞ', 'N5', 'please');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('動物', 'どうぶつ', 'N5', 'animal');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どうも', 'どうも', 'N5', 'thanks / hello / somehow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('遠い', 'とおい', 'N5', 'far');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('十日', 'とおか', 'N5', 'tenth day / ten days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('時々', 'ときどき', 'N5', 'sometimes');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('時計', 'とけい', 'N5', 'clock / watch');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どこ', 'どこ', 'N5', 'where');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('所', 'ところ', 'N5', 'place');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('年', 'とし', 'N5', 'year');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('図書館', 'としょかん', 'N5', 'library');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どちら', 'どちら', 'N5', 'which way / which one');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どっち', 'どっち', 'N5', 'which (coll.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('とても', 'とても', 'N5', 'very / extremely');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どなた', 'どなた', 'N5', 'who (polite)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('隣', 'となり', 'N5', 'next to / neighbor');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どの', 'どの', 'N5', 'which (before noun)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('飛ぶ', 'とぶ', 'N5', 'to fly / to jump');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('止まる', 'とまる', 'N5', 'to stop (intransitive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('友達', 'ともだち', 'N5', 'friend');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('土曜日', 'どようび', 'N5', 'Saturday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('鳥', 'とり', 'N5', 'bird');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('とり肉', 'とりにく', 'N5', 'chicken meat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('取る', 'とる', 'N5', 'to take / to get');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('撮る', 'とる', 'N5', 'to take (photo)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('どれ', 'どれ', 'N5', 'which one');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ナイフ', 'ナイフ', 'N5', 'knife');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('中', 'なか', 'N5', 'inside / middle');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('長い', 'ながい', 'N5', 'long');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('鳴く', 'なく', 'N5', 'to cry (animal)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('無くす', 'なくす', 'N5', 'to lose / to get rid of');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('なぜ', 'なぜ', 'N5', 'why');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('夏', 'なつ', 'N5', 'summer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('夏休み', 'なつやすみ', 'N5', 'summer vacation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('など', 'など', 'N5', 'such as / etc.');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('七つ', 'ななつ', 'N5', 'seven (things)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('七日', 'なのか', 'N5', 'seventh day / seven days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('名前', 'なまえ', 'N5', 'name');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('習う', 'ならう', 'N5', 'to learn');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('並ぶ', 'ならぶ', 'N5', 'to line up / to stand in line');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('並べる', 'ならべる', 'N5', 'to line up (transitive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('なる', 'なる', 'N5', 'to become');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('何', 'なん', 'N5', 'what');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('何', 'なに', 'N5', 'what');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('二', 'に', 'N5', 'two');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('賑やか', 'にぎやか', 'N5', 'lively / bustling');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('肉', 'にく', 'N5', 'meat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('西', 'にし', 'N5', 'west');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('日曜日', 'にちようび', 'N5', 'Sunday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('荷物', 'にもつ', 'N5', 'baggage / package');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ニュース', 'ニュース', 'N5', 'news');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('庭', 'にわ', 'N5', 'garden');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('脱ぐ', 'ぬぐ', 'N5', 'to take off (clothes)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('温い', 'ぬるい', 'N5', 'lukewarm');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ネクタイ', 'ネクタイ', 'N5', 'necktie');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('猫', 'ねこ', 'N5', 'cat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('寝る', 'ねる', 'N5', 'to sleep / to go to bed');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ノート', 'ノート', 'N5', 'notebook');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('登る', 'のぼる', 'N5', 'to climb');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('飲み物', 'のみもの', 'N5', 'drink / beverage');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('飲む', 'のむ', 'N5', 'to drink');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('乗る', 'のる', 'N5', 'to ride / to board');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('歯', 'は', 'N5', 'tooth');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('パーティー', 'パーティー', 'N5', 'party');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('はい', 'はい', 'N5', 'yes');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('灰皿', 'はいざら', 'N5', 'ashtray');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('入る', 'はいる', 'N5', 'to enter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('葉書', 'はがき', 'N5', 'postcard');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('はく', 'はく', 'N5', 'to wear (below waist) / to sweep');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('箱', 'はこ', 'N5', 'box');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('橋', 'はし', 'N5', 'bridge');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('はし', 'はし', 'N5', 'chopsticks');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('始まる', 'はじまる', 'N5', 'to begin (intransitive)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('初め', 'はじめ', 'N5', 'beginning');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('始め', 'はじめ', 'N5', 'beginning');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('初めて', 'はじめて', 'N5', 'for the first time');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('走る', 'はしる', 'N5', 'to run');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('バス', 'バス', 'N5', 'bus');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('バター', 'バター', 'N5', 'butter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('二十歳', 'はたち', 'N5', '20 years old');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('働く', 'はたらく', 'N5', 'to work');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('八', 'はち', 'N5', 'eight');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('二十日', 'はつか', 'N5', '20th day / 20 days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('花', 'はな', 'N5', 'flower');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('鼻', 'はな', 'N5', 'nose');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('話', 'はなし', 'N5', 'story / talk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('話す', 'はなす', 'N5', 'to speak / to talk');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('早い', 'はやい', 'N5', 'early / fast');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('速い', 'はやい', 'N5', 'fast');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('春', 'はる', 'N5', 'spring (season)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('貼る', 'はる', 'N5', 'to stick / to paste');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('晴れ', 'はれ', 'N5', 'fair weather');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('晴れる', 'はれる', 'N5', 'to clear up (weather)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('半', 'はん', 'N5', 'half');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('晩', 'ばん', 'N5', 'evening');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('パン', 'パン', 'N5', 'bread');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ハンカチ', 'ハンカチ', 'N5', 'handkerchief');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('番号', 'ばんごう', 'N5', 'number');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('晩御飯', 'ばんごはん', 'N5', 'dinner');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('半分', 'はんぶん', 'N5', 'half');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('東', 'ひがし', 'N5', 'east');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('引く', 'ひく', 'N5', 'to pull / to subtract');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('弾く', 'ひく', 'N5', 'to play (instrument)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('低い', 'ひくい', 'N5', 'low / short');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('飛行機', 'ひこうき', 'N5', 'airplane');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('左', 'ひだり', 'N5', 'left');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('人', 'ひと', 'N5', 'person');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一つ', 'ひとつ', 'N5', 'one (thing)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一月', 'ひとつき', 'N5', 'one month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('一人', 'ひとり', 'N5', 'one person / alone');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('暇', 'ひま', 'N5', 'free time / spare time');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('百', 'ひゃく', 'N5', 'one hundred');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('病院', 'びょういん', 'N5', 'hospital');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('病気', 'びょうき', 'N5', 'illness / disease');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('昼', 'ひる', 'N5', 'afternoon / daytime');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('昼御飯', 'ひるごはん', 'N5', 'lunch');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('広い', 'ひろい', 'N5', 'wide / spacious');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('フィルム', 'フィルム', 'N5', 'film (camera)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('封筒', 'ふうとう', 'N5', 'envelope');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('プール', 'プール', 'N5', 'pool');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('フォーク', 'フォーク', 'N5', 'fork');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('吹く', 'ふく', 'N5', 'to blow (wind)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('服', 'ふく', 'N5', 'clothes');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('二つ', 'ふたつ', 'N5', 'two (things)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('豚肉', 'ぶたにく', 'N5', 'pork');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('二人', 'ふたり', 'N5', 'two people');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('二日', 'ふつか', 'N5', 'second day / two days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('太い', 'ふとい', 'N5', 'thick / fat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('冬', 'ふゆ', 'N5', 'winter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('降る', 'ふる', 'N5', 'to fall (rain/snow)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('古い', 'ふるい', 'N5', 'old (not new)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ふろ', 'ふろ', 'N5', 'bath (as in お風呂)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('文章', 'ぶんしょう', 'N5', 'sentence / writing');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ページ', 'ページ', 'N5', 'page');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('下手', 'へた', 'N5', 'unskilled / poor at');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ベッド', 'ベッド', 'N5', 'bed');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ペット', 'ペット', 'N5', 'pet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('部屋', 'へや', 'N5', 'room');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('辺', 'へん', 'N5', 'area / vicinity');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ペン', 'ペン', 'N5', 'pen');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('勉強する', 'べんきょうする', 'N5', 'to study');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('便利', 'べんり', 'N5', 'convenient');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('帽子', 'ぼうし', 'N5', 'hat');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ボールペン', 'ボールペン', 'N5', 'ballpoint pen');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ほか', 'ほか', 'N5', 'other / besides');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ポケット', 'ポケット', 'N5', 'pocket');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('欲しい', 'ほしい', 'N5', 'wanted / desirable');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ポスト', 'ポスト', 'N5', 'mailbox / post');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('細い', 'ほそい', 'N5', 'thin / slender');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ボタン', 'ボタン', 'N5', 'button');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ホテル', 'ホテル', 'N5', 'hotel');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('本', 'ほん', 'N5', 'book');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('本棚', 'ほんだな', 'N5', 'bookshelf');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ほんとう', 'ほんとう', 'N5', 'real / true');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毎朝', 'まいあさ', 'N5', 'every morning');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毎月', 'まいげつ', 'N5', 'every month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毎月', 'まいつき', 'N5', 'every month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毎週', 'まいしゅう', 'N5', 'every week');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毎日', 'まいにち', 'N5', 'every day');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毎年', 'まいねん', 'N5', 'every year');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毎年', 'まいとし', 'N5', 'every year');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('毎晩', 'まいばん', 'N5', 'every evening');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('前', 'まえ', 'N5', 'before / front');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('曲る', 'まがる', 'N5', 'to turn / to bend');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('まずい', 'まずい', 'N5', 'unappetizing / poor / bad');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('また', 'また', 'N5', 'again / also');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('まだ', 'まだ', 'N5', 'still / not yet');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('町', 'まち', 'N5', 'town / street');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('待つ', 'まつ', 'N5', 'to wait');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('まっすぐ', 'まっすぐ', 'N5', 'straight / honest');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('マッチ', 'マッチ', 'N5', 'match (for fire)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('窓', 'まど', 'N5', 'window');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('丸い', 'まるい', 'N5', 'round / circular');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('円い', 'まるい', 'N5', 'round');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('万', 'まん', 'N5', 'ten thousand');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('万年筆', 'まんねんひつ', 'N5', 'fountain pen');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('磨く', 'みがく', 'N5', 'to polish / to brush');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('右', 'みぎ', 'N5', 'right');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('短い', 'みじかい', 'N5', 'short (length)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('水', 'みず', 'N5', 'water');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('店', 'みせ', 'N5', 'shop / store');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('見せる', 'みせる', 'N5', 'to show');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('道', 'みち', 'N5', 'road / way');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('三日', 'みっか', 'N5', 'third day / three days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('三つ', 'みっつ', 'N5', 'three (things)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('緑', 'みどり', 'N5', 'green');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('皆さん', 'みなさん', 'N5', 'everyone (polite)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('南', 'みなみ', 'N5', 'south');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('耳', 'みみ', 'N5', 'ear');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('見る', 'みる', 'N5', 'to see / to watch');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('観る', 'みる', 'N5', 'to watch (movie etc.)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('みんな', 'みんな', 'N5', 'everyone / all');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('六日', 'むいか', 'N5', 'sixth day / six days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('向こう', 'むこう', 'N5', 'beyond / opposite side');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('難しい', 'むずかしい', 'N5', 'difficult');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('六つ', 'むっつ', 'N5', 'six (things)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('村', 'むら', 'N5', 'village');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('目', 'め', 'N5', 'eye');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('メートル', 'メートル', 'N5', 'meter');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('眼鏡', 'めがね', 'N5', 'eyeglasses');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('もう', 'もう', 'N5', 'already / soon / more');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('もう一度', 'もういちど', 'N5', 'one more time');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('木曜日', 'もくようび', 'N5', 'Thursday');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('持つ', 'もつ', 'N5', 'to hold / to have');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('もっと', 'もっと', 'N5', 'more / further');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('物', 'もの', 'N5', 'thing');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('門', 'もん', 'N5', 'gate');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('問題', 'もんだい', 'N5', 'problem / question');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('八百屋', 'やおや', 'N5', 'greengrocer');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('野菜', 'やさい', 'N5', 'vegetable');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('易しい', 'やさしい', 'N5', 'easy');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('安い', 'やすい', 'N5', 'cheap / inexpensive');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('休み', 'やすみ', 'N5', 'rest / vacation');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('休む', 'やすむ', 'N5', 'to rest / to take a break');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('八つ', 'やっつ', 'N5', 'eight (things)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('山', 'やま', 'N5', 'mountain');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('やる', 'やる', 'N5', 'to do / to give (to inferiors)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('夕方', 'ゆうがた', 'N5', 'evening');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('夕飯', 'ゆうはん', 'N5', 'dinner');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('郵便局', 'ゆうびんきょく', 'N5', 'post office');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('昨夜', 'ゆうべ', 'N5', 'last night / yesterday evening');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('有名', 'ゆうめい', 'N5', 'famous');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('雪', 'ゆき', 'N5', 'snow');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('行く', 'ゆく', 'N5', 'to go (alternative)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ゆっくりと', 'ゆっくりと', 'N5', 'slowly');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('八日', 'ようか', 'N5', 'eighth day / eight days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('洋服', 'ようふく', 'N5', 'Western-style clothes');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('よく', 'よく', 'N5', 'often / well');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('横', 'よこ', 'N5', 'side / horizontal');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('四日', 'よっか', 'N5', 'fourth day / four days');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('四つ', 'よっつ', 'N5', 'four (things)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('呼ぶ', 'よぶ', 'N5', 'to call / to invite');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('読む', 'よむ', 'N5', 'to read');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('夜', 'よる', 'N5', 'night / evening');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('弱い', 'よわい', 'N5', 'weak');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('来月', 'らいげつ', 'N5', 'next month');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('来週', 'らいしゅう', 'N5', 'next week');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('来年', 'らいねん', 'N5', 'next year');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ラジオ', 'ラジオ', 'N5', 'radio');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ラジカセ', 'ラジカセ', 'N5', 'radio cassette player');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ラジオカセット', 'ラジオカセット', 'N5', 'radio cassette recorder');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('りっぱ', 'りっぱ', 'N5', 'splendid / fine');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('留学生', 'りゅうがくせい', 'N5', 'international student');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('両親', 'りょうしん', 'N5', 'parents');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('料理', 'りょうり', 'N5', 'cooking / dish');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('旅行', 'りょこう', 'N5', 'travel / trip');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('零', 'れい', 'N5', 'zero');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('冷蔵庫', 'れいぞうこ', 'N5', 'refrigerator');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('レコード', 'レコード', 'N5', 'record');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('レストラン', 'レストラン', 'N5', 'restaurant');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('練習する', 'れんしゅうする', 'N5', 'to practice');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('廊下', 'ろうか', 'N5', 'hallway / corridor');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('六', 'ろく', 'N5', 'six');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ワイシャツ', 'ワイシャツ', 'N5', 'dress shirt');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('若い', 'わかい', 'N5', 'young');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('分かる', 'わかる', 'N5', 'to understand');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('忘れる', 'わすれる', 'N5', 'to forget');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('私', 'わたくし', 'N5', 'I (formal)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('私', 'わたし', 'N5', 'I');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('渡す', 'わたす', 'N5', 'to hand over / to pass');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('渡る', 'わたる', 'N5', 'to cross / to go across');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('悪い', 'わるい', 'N5', 'bad / wrong');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('より', 'より', 'N5', 'than / from');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('より', 'ほう', 'N5', 'direction / side (as in よりほう)');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ほう', 'より', 'N5', 'side / better');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level, meaning) VALUES ('ほう', 'ほう', 'N5', 'side / way');
