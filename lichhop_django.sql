-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 25, 2026 at 12:35 PM
-- Server version: 10.11.16-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lichhop_django`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add session', 5, 'add_session'),
(18, 'Can change session', 5, 'change_session'),
(19, 'Can delete session', 5, 'delete_session'),
(20, 'Can view session', 5, 'view_session'),
(21, 'Can add member', 6, 'add_member'),
(22, 'Can change member', 6, 'change_member'),
(23, 'Can delete member', 6, 'delete_member'),
(24, 'Can view member', 6, 'view_member'),
(25, 'Can add room', 7, 'add_room'),
(26, 'Can change room', 7, 'change_room'),
(27, 'Can delete room', 7, 'delete_room'),
(28, 'Can view room', 7, 'view_room'),
(29, 'Can add user', 8, 'add_user'),
(30, 'Can change user', 8, 'change_user'),
(31, 'Can delete user', 8, 'delete_user'),
(32, 'Can view user', 8, 'view_user'),
(33, 'Can add meeting', 9, 'add_meeting'),
(34, 'Can change meeting', 9, 'change_meeting'),
(35, 'Can delete meeting', 9, 'delete_meeting'),
(36, 'Can view meeting', 9, 'view_meeting'),
(37, 'Can add meeting file', 10, 'add_meetingfile'),
(38, 'Can change meeting file', 10, 'change_meetingfile'),
(39, 'Can delete meeting file', 10, 'delete_meetingfile'),
(40, 'Can view meeting file', 10, 'view_meetingfile'),
(41, 'Can add meeting attendee', 11, 'add_meetingattendee'),
(42, 'Can change meeting attendee', 11, 'change_meetingattendee'),
(43, 'Can delete meeting attendee', 11, 'delete_meetingattendee'),
(44, 'Can view meeting attendee', 11, 'view_meetingattendee'),
(45, 'Can add checkin record', 12, 'add_checkinrecord'),
(46, 'Can change checkin record', 12, 'change_checkinrecord'),
(47, 'Can delete checkin record', 12, 'delete_checkinrecord'),
(48, 'Can view checkin record', 12, 'view_checkinrecord'),
(49, 'Can add notification', 13, 'add_notification'),
(50, 'Can change notification', 13, 'change_notification'),
(51, 'Can delete notification', 13, 'delete_notification'),
(52, 'Can view notification', 13, 'view_notification'),
(53, 'Can add conflict acknowledgement', 14, 'add_conflictacknowledgement'),
(54, 'Can change conflict acknowledgement', 14, 'change_conflictacknowledgement'),
(55, 'Can delete conflict acknowledgement', 14, 'delete_conflictacknowledgement'),
(56, 'Can view conflict acknowledgement', 14, 'view_conflictacknowledgement');

-- --------------------------------------------------------

--
-- Table structure for table `checkin_records`
--

CREATE TABLE `checkin_records` (
  `id` bigint(20) NOT NULL,
  `checkin_time` datetime(6) DEFAULT NULL,
  `meeting_id` bigint(20) NOT NULL,
  `member_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `checkin_records`
--

INSERT INTO `checkin_records` (`id`, `checkin_time`, `meeting_id`, `member_id`) VALUES
(2316, NULL, 619, 1486),
(2317, NULL, 619, 1487),
(2318, NULL, 619, 1489),
(2319, NULL, 619, 1490),
(2320, NULL, 619, 1491),
(2321, NULL, 620, 1486),
(2322, NULL, 620, 1488),
(2323, NULL, 620, 1507),
(2324, NULL, 621, 1486),
(2325, NULL, 621, 1487),
(2326, NULL, 621, 1488),
(2327, NULL, 621, 1489),
(2328, NULL, 621, 1490),
(2329, NULL, 621, 1491),
(2330, NULL, 621, 1507),
(2331, NULL, 621, 1518),
(2332, NULL, 621, 1519),
(2333, NULL, 622, 1486),
(2334, NULL, 622, 1488),
(2335, NULL, 622, 1491),
(2336, NULL, 622, 1507),
(2337, NULL, 622, 1513),
(2338, NULL, 622, 1514),
(2339, NULL, 622, 1517),
(2340, NULL, 622, 1520),
(2341, NULL, 623, 1490),
(2342, NULL, 623, 1491),
(2343, '2026-08-17 01:02:00.000000', 624, 1486),
(2344, '2026-08-17 01:00:00.000000', 624, 1488),
(2345, '2026-08-17 00:57:00.000000', 624, 1491),
(2346, NULL, 624, 1507),
(2347, NULL, 625, 1491),
(2348, NULL, 625, 1492),
(2349, NULL, 625, 1507),
(2350, NULL, 625, 1502),
(2351, NULL, 625, 1493),
(2352, '2026-08-24 02:28:00.000000', 626, 1492),
(2353, NULL, 626, 1502),
(2354, '2026-08-24 02:30:00.000000', 626, 1493),
(2355, '2026-08-10 01:31:00.000000', 627, 1502),
(2356, '2026-08-10 01:29:00.000000', 627, 1507),
(2357, NULL, 628, 1486),
(2358, NULL, 628, 1488),
(2359, NULL, 628, 1489),
(2360, NULL, 629, 1489),
(2361, NULL, 629, 1491),
(2362, NULL, 630, 1490),
(2363, NULL, 630, 1507),
(2364, NULL, 630, 1515),
(2365, NULL, 631, 1486),
(2366, NULL, 631, 1518),
(2367, NULL, 632, 1489),
(2368, NULL, 632, 1491),
(2369, NULL, 633, 1491),
(2370, NULL, 633, 1492),
(2371, NULL, 634, 1507),
(2372, NULL, 634, 1502),
(2373, '2026-07-31 00:58:00.000000', 635, 1488),
(2374, '2026-07-31 01:03:00.000000', 635, 1517),
(2375, '2026-07-31 01:01:00.000000', 635, 1518),
(2376, '2026-07-31 01:05:00.000000', 635, 1519),
(2377, '2026-07-26 00:55:00.000000', 636, 1491),
(2378, '2026-07-26 01:00:00.000000', 636, 1492),
(2379, '2026-07-26 01:04:00.000000', 636, 1493),
(2380, NULL, 636, 1494),
(2381, NULL, 636, 1495);

-- --------------------------------------------------------

--
-- Table structure for table `conflict_acknowledgements`
--

CREATE TABLE `conflict_acknowledgements` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `acknowledged_by_id` bigint(20) DEFAULT NULL,
  `meeting_a_id` bigint(20) NOT NULL,
  `meeting_b_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `conflict_acknowledgements`
--

INSERT INTO `conflict_acknowledgements` (`id`, `created_at`, `acknowledged_by_id`, `meeting_a_id`, `meeting_b_id`) VALUES
(27, '2026-08-25 10:32:06.791996', 542, 630, 631);

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'contenttypes', 'contenttype'),
(12, 'core', 'checkinrecord'),
(14, 'core', 'conflictacknowledgement'),
(9, 'core', 'meeting'),
(11, 'core', 'meetingattendee'),
(10, 'core', 'meetingfile'),
(6, 'core', 'member'),
(13, 'core', 'notification'),
(7, 'core', 'room'),
(8, 'core', 'user'),
(5, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-08-22 12:19:42.373884'),
(2, 'contenttypes', '0002_remove_content_type_name', '2026-08-22 12:19:42.437476'),
(3, 'auth', '0001_initial', '2026-08-22 12:19:42.558966'),
(4, 'auth', '0002_alter_permission_name_max_length', '2026-08-22 12:19:42.579028'),
(5, 'auth', '0003_alter_user_email_max_length', '2026-08-22 12:19:42.582910'),
(6, 'auth', '0004_alter_user_username_opts', '2026-08-22 12:19:42.587075'),
(7, 'auth', '0005_alter_user_last_login_null', '2026-08-22 12:19:42.590406'),
(8, 'auth', '0006_require_contenttypes_0002', '2026-08-22 12:19:42.591508'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2026-08-22 12:19:42.595172'),
(10, 'auth', '0008_alter_user_username_max_length', '2026-08-22 12:19:42.598473'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2026-08-22 12:19:42.602051'),
(12, 'auth', '0010_alter_group_name_max_length', '2026-08-22 12:19:42.612277'),
(13, 'auth', '0011_update_proxy_permissions', '2026-08-22 12:19:42.616523'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2026-08-22 12:19:42.619754'),
(15, 'core', '0001_initial', '2026-08-22 12:19:42.948069'),
(16, 'admin', '0001_initial', '2026-08-22 12:19:42.993282'),
(17, 'admin', '0002_logentry_remove_auto_add', '2026-08-22 12:19:43.000866'),
(18, 'admin', '0003_logentry_add_action_flag_choices', '2026-08-22 12:19:43.008013'),
(19, 'sessions', '0001_initial', '2026-08-22 12:19:43.024544'),
(20, 'core', '0002_meeting_postponed_alter_user_role', '2026-08-24 02:29:54.778312'),
(21, 'core', '0003_notification', '2026-08-24 03:16:11.568905'),
(22, 'core', '0004_remove_meetingfile_storage_path_meeting_is_draft_and_more', '2026-08-24 13:48:53.125859'),
(23, 'core', '0005_user_can_manage_rooms', '2026-08-25 10:06:16.328115');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0cwvftbgr9wmqiu5fgkftf97t4qjvzov', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyR19:7RQ0ZDxxJLgaX_Bh4m1t-dpwevlwq2_TeD-NgQ6Vt9w', '2026-09-07 09:30:59.603037'),
('1nwih1w9r5uiv9d605vwezv94uqi0eow', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyR7n:KtCO6v4CCN4yFm9ceYoPeB8aw78uQnku6iijV7pQz1U', '2026-09-07 09:37:51.503485'),
('5afnwfhx46mpwxwxrjihh5qxl1l50szr', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyQRH:LihmC66qpnPyilLDcQTPGZ3dT8KRHVrSIrjAh3vuwhU', '2026-09-07 08:53:55.029782'),
('77mvwhh590zpqeiiirj8tmgbw8g8g872', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyRB3:MIiK3QyVAnYRab0K_5i2S631spvIu37mATLcZpJrWek', '2026-09-07 09:41:13.967778'),
('796m2qja68sf1miagiqnjt8gkyccm2ve', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyRBc:M00x0Dgb0GFqODTCeay9Pq-PRpz97yLfNW9yPOYDRFk', '2026-09-07 09:41:48.526648'),
('98e9it6qv9l4fcvxknyjj8unzz3v1yh0', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyQr7:dqnjbCRY8DGq7uxeoG9hqF1kOSDTMpSSgLl5UfEzIAU', '2026-09-07 09:20:37.328508'),
('9go6h4cmjg64k22k0t74i0ufdor901vy', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyRNL:tkhwj39Sb2z_-SQ_Y4GpjebbXkWo13B8EgiNCbIaCIs', '2026-09-07 09:53:55.958968'),
('fddg3e0tx52bj9ypd8s86wc99dpjhd4u', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyR4u:siZvNFuuuMGucmt5boZ9xVHwp3vi_o2pZ8QG8Ng2I-o', '2026-09-07 09:34:52.829490'),
('geixz0f6tueewbzyx3a8dd2isg7uizcb', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyQQd:rdfHBDw2POYPiOXwVsTs-DS88BJhPRTMeIER5tMZfPQ', '2026-09-07 08:53:15.369277'),
('j3qf7wfvygj74oak5zud7q4mc2vrcnks', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyR7Z:bGNo2e-d-vYwY9Q8gzSuRxssp0rLZNamin1cDsa-h2s', '2026-09-07 09:37:37.854833'),
('jp443pgw0ca784cdudyhtk2yibzuv530', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyR55:CXsGfKObYpgLE3H5g7Fr_7MMRJLEXaFFt5W1vALDz7c', '2026-09-07 09:35:03.242306'),
('jsynvwwdqumt5jagg8nuqn7yhcqv9a1w', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyQv3:RfflemXV9_QYSAJE_U_UNfdNV3RbCOksZCZI8oUhjXU', '2026-09-07 09:24:41.849679'),
('ly15tuf0melqptrn56ba6qhw8vnusl2f', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyQrf:dww80HlG-awKguQO5yWvLc1op66g0CFihnAgRhPmKEU', '2026-09-07 09:21:11.145575'),
('mw1bjdbog0a66tpft4t72vjyrcgrhs53', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyR1s:bnMt_FoKx02xdFEQ7VlirvrkMdtB2zpVfzlYeUH0r-I', '2026-09-07 09:31:44.711931'),
('n1oyy00k91g64fqp7jv06pjvxscvc3n0', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyQsn:H06o37EHmldUiovQDwCi5jcf67IwhCPwkMEYPFHKPUk', '2026-09-07 09:22:21.671562'),
('r6g845b3cjyk29nnfygjw6a8trs0bijk', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyRGK:XBNHDVFJDDU4X7n1Ww7RL0EnwOqbKKHTcLVCr41fhkw', '2026-09-07 09:46:40.952558'),
('rcs47okq00ryeqrl6dwtrxx2qcuorts1', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyR9E:D8t_W7-T5ViWRnmIQBWJrNDUn8ptZKhQsLXbaJFLt2E', '2026-09-07 09:39:20.988831'),
('roqy606nc6z95mfykpv1yu7wlgk4kjjm', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyR8R:iHqCjc5pKpvJQZ1KPWe6FKq5OSzCGnylIfClDj-PesE', '2026-09-07 09:38:31.502440'),
('vwz0p8uco809js6pora3vsbpv70mdwiq', '.eJxVjDsOwjAQBe_iGllx4i8lfc5g7XrXOIAcKU4qxN1JpBTQvpl5bxFhW0vcGi9xInEVzorL74iQnlwPQg-o91mmua7LhPJQ5EmbHGfi1-10_w4KtLLXmTRrBJ8dBzukHrPOSXGPrNgYy85jYIcEJiuEgYz3u89JUwiOu058vk7ZOaQ:1wyR7I:CoR5dC4iU90SdttFBFOxQiRD4qV2pWxTedWiw1jgcBg', '2026-09-07 09:37:20.242458'),
('yapbx1uwydwc2nyfsmf6emvbldflqpq3', '.eJxVjEEOwiAQRe_C2hAGCoJL9z0DGWaoVA0kpV0Z765NutDtf-_9l4i4rSVuPS9xZnERZydOv2NCeuS6E75jvTVJra7LnOSuyIN2OTbOz-vh_h0U7OVb4xSCyyYoxwQZEk4-JLJeBxM0IhlHGdBbMwApq8Cy9kCaB8VAFkm8PxcIOCo:1wyQzH:V9FTU_MJoALboI2r7m2WspFb9zqpfPk6v0Lf6V1v32w', '2026-09-07 09:29:03.185753');

-- --------------------------------------------------------

--
-- Table structure for table `meetings`
--

CREATE TABLE `meetings` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `meeting_date` date NOT NULL,
  `start_time` time(6) NOT NULL,
  `session` varchar(10) NOT NULL,
  `level` varchar(15) NOT NULL,
  `location_text` varchar(255) DEFAULT NULL,
  `unit` varchar(150) DEFAULT NULL,
  `host` varchar(150) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `estimated_people` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` bigint(20) DEFAULT NULL,
  `room_id` bigint(20) DEFAULT NULL,
  `postponed` tinyint(1) NOT NULL,
  `is_draft` tinyint(1) NOT NULL,
  `minutes` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `meetings`
--

INSERT INTO `meetings` (`id`, `title`, `meeting_date`, `start_time`, `session`, `level`, `location_text`, `unit`, `host`, `content`, `estimated_people`, `created_at`, `updated_at`, `created_by_id`, `room_id`, `postponed`, `is_draft`, `minutes`) VALUES
(619, 'Họp giao ban tuần', '2026-08-28', '08:00:00.000000', 'am', 'uy_ban', NULL, 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật: Giao ban công tác tuần.', 20, '2026-08-25 10:32:06.623126', '2026-08-25 10:32:06.623139', NULL, 186, 0, 0, ''),
(620, 'Làm việc với đoàn công tác Thành phố', '2026-08-28', '10:00:00.000000', 'am', 'uy_ban', NULL, 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật: Tiếp và làm việc với đoàn công tác Thành phố.', 12, '2026-08-25 10:32:06.633497', '2026-08-25 10:32:06.633511', NULL, 186, 0, 0, ''),
(621, 'Phiên họp thường kỳ HĐND phường', '2026-09-01', '08:00:00.000000', 'all_day', 'uy_ban', NULL, 'Nguyễn Duy An', 'Nguyễn Duy An', 'Nguyễn Duy An: Phiên họp thường kỳ Hội đồng nhân dân phường.', 65, '2026-08-25 10:32:06.638883', '2026-08-25 10:32:06.638899', NULL, 188, 0, 0, ''),
(622, 'Hội nghị triển khai kế hoạch quý 4', '2026-09-04', '08:30:00.000000', 'am', 'uy_ban', NULL, 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật: Triển khai kế hoạch công tác quý 4 tới các đơn vị.', 45, '2026-08-25 10:32:06.662186', '2026-08-25 10:32:06.662204', NULL, 188, 0, 0, ''),
(623, 'Họp rà soát công tác tháng 8 (đã hoãn)', '2026-08-27', '14:00:00.000000', 'pm', 'uy_ban', NULL, 'Thái Thị Kim Thanh', 'Thái Thị Kim Thanh', 'Thái Thị Kim Thanh: Rà soát công tác tháng 8, dời sang tuần sau.', 8, '2026-08-25 10:32:06.684907', '2026-08-25 10:32:06.684922', NULL, 187, 1, 0, ''),
(624, 'Tổng kết công tác 6 tháng đầu năm', '2026-08-17', '08:00:00.000000', 'am', 'uy_ban', NULL, 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật: Tổng kết công tác 6 tháng đầu năm.', 50, '2026-08-25 10:32:06.688565', '2026-08-25 10:32:06.688578', NULL, 188, 0, 0, 'BIEN BAN TOM TAT\nThoi gian: 08:00 - 17/08/2026\nChu tri: Bo Ky Thuat - Chu tich UBND phuong\nNoi dung: Danh gia ket qua cong tac 6 thang dau nam, de ra phuong huong nhiem vu 6 thang cuoi nam.\nKet luan: Thong nhat trien khai theo ke hoach da bao cao, giao Van phong theo doi, do doc thuc hien.'),
(625, 'Họp giao ban Văn phòng tuần', '2026-08-26', '09:00:00.000000', 'am', 'phong_ban', 'Phòng họp Văn phòng', 'Văn phòng HĐND-UBND', 'Dư Quang Nghĩa', 'Dư Quang Nghĩa: Giao ban công tác Văn phòng trong tuần.', 12, '2026-08-25 10:32:06.700743', '2026-08-25 10:32:06.700758', NULL, NULL, 0, 0, ''),
(626, 'Rà soát hồ sơ thi đua khen thưởng', '2026-08-24', '09:30:00.000000', 'am', 'phong_ban', 'Phòng họp Văn phòng', 'Văn phòng HĐND-UBND', 'Nguyễn Duy Toán', 'Nguyễn Duy Toán: Rà soát hồ sơ thi đua khen thưởng quý 3.', 10, '2026-08-25 10:32:06.709512', '2026-08-25 10:32:06.709527', NULL, NULL, 0, 0, ''),
(627, 'Trao đổi nghiệp vụ văn thư - lưu trữ', '2026-08-10', '08:30:00.000000', 'am', 'phong_ban', 'Phòng họp Văn phòng', 'Văn phòng HĐND-UBND', 'Nguyễn Minh Thanh', 'Nguyễn Minh Thanh: Trao đổi nghiệp vụ văn thư - lưu trữ định kỳ.', 8, '2026-08-25 10:32:06.716197', '2026-08-25 10:32:06.716210', NULL, NULL, 0, 0, 'BIEN BAN TRAO DOI NGHIEP VU\nDa thong nhat quy trinh luu tru ho so dien tu ap dung tu thang toi, phan cong Nguyen Thi Ngoc Han chu tri huong dan cac phong ban.'),
(628, 'Hội ý lãnh đạo đầu tuần', '2026-08-30', '07:30:00.000000', 'all_day', 'uy_ban', NULL, 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật: Hội ý lãnh đạo đầu tuần, xuyên suốt cả ngày.', 6, '2026-08-25 10:32:06.720188', '2026-08-25 10:32:06.720202', NULL, 185, 0, 0, ''),
(629, 'Trao đổi công tác nhân sự', '2026-08-30', '14:00:00.000000', 'pm', 'uy_ban', NULL, 'Đinh Vũ Thắng', 'Đinh Vũ Thắng', 'Đinh Vũ Thắng: Trao đổi công tác nhân sự — TRÙNG với hội ý lãnh đạo (buổi Cả ngày).', 4, '2026-08-25 10:32:06.729935', '2026-08-25 10:32:06.729950', NULL, 185, 0, 0, ''),
(630, 'Họp chuyên đề cải cách hành chính', '2026-08-31', '08:00:00.000000', 'am', 'uy_ban', NULL, 'Thái Thị Kim Thanh', 'Thái Thị Kim Thanh', 'Thái Thị Kim Thanh: Chuyên đề cải cách hành chính quý 4.', 15, '2026-08-25 10:32:06.735231', '2026-08-25 10:32:06.735246', NULL, 187, 0, 0, ''),
(631, 'Tiếp công dân định kỳ', '2026-08-31', '08:30:00.000000', 'am', 'uy_ban', NULL, 'Nguyễn Duy An', 'Nguyễn Duy An', 'Nguyễn Duy An: Tiếp công dân định kỳ — trùng phòng nhưng đã được điều phối ổn thỏa.', 6, '2026-08-25 10:32:06.743220', '2026-08-25 10:32:06.743234', NULL, 187, 0, 0, ''),
(632, 'Dự kiến họp chuyên đề chuyển đổi số', '2026-09-06', '08:00:00.000000', 'am', 'uy_ban', NULL, 'Đinh Vũ Thắng', 'Đinh Vũ Thắng', 'Đinh Vũ Thắng: (Nháp) Dự kiến chuyên đề chuyển đổi số, chưa công bố chính thức.', 30, '2026-08-25 10:32:06.748858', '2026-08-25 10:32:06.748874', NULL, 188, 0, 1, ''),
(633, 'Dự kiến rà soát KPI quý 4 Văn phòng', '2026-09-03', '09:00:00.000000', 'am', 'phong_ban', 'Phòng họp Văn phòng', 'Văn phòng HĐND-UBND', 'Dư Quang Nghĩa', 'Dư Quang Nghĩa: (Nháp) Dự kiến rà soát KPI quý 4, chưa công bố.', 10, '2026-08-25 10:32:06.754091', '2026-08-25 10:32:06.754105', NULL, NULL, 0, 1, ''),
(634, 'Họp chuyên đề văn thư lưu trữ điện tử', '2026-08-29', '14:00:00.000000', 'pm', 'phong_ban', 'Phòng họp Văn phòng', 'Văn phòng HĐND-UBND', 'Nguyễn Thị Ngọc Hân', 'Nguyễn Thị Ngọc Hân: Chuyên đề văn thư lưu trữ điện tử — đã hoãn, chờ lịch mới.', 8, '2026-08-25 10:32:06.758598', '2026-08-25 10:32:06.758612', NULL, NULL, 1, 0, ''),
(635, 'Họp Ban Chỉ đạo phòng chống thiên tai', '2026-07-31', '08:00:00.000000', 'am', 'uy_ban', NULL, 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật', 'Bồ Kỹ Thuật: Họp Ban Chỉ đạo phòng chống thiên tai và tìm kiếm cứu nạn.', 20, '2026-08-25 10:32:06.764964', '2026-08-25 10:32:06.764979', NULL, 188, 0, 0, 'BIEN BAN HOP BAN CHI DAO PCTT-TKCN\nDa ra soat phuong an ung pho mua bao nam nay, phan cong truc 24/24 trong mua mua bao, thong nhat danh muc trang thiet bi can bo sung.'),
(636, 'Họp giao ban Văn phòng đầu tháng', '2026-07-26', '08:00:00.000000', 'am', 'phong_ban', 'Phòng họp Văn phòng', 'Văn phòng HĐND-UBND', 'Dư Quang Nghĩa', 'Dư Quang Nghĩa: Giao ban Văn phòng đầu tháng.', 10, '2026-08-25 10:32:06.775277', '2026-08-25 10:32:06.775289', NULL, NULL, 0, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `meeting_attendees`
--

CREATE TABLE `meeting_attendees` (
  `id` bigint(20) NOT NULL,
  `status` varchar(10) NOT NULL,
  `decline_reason` longtext DEFAULT NULL,
  `responded_at` datetime(6) DEFAULT NULL,
  `meeting_id` bigint(20) NOT NULL,
  `member_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `meeting_attendees`
--

INSERT INTO `meeting_attendees` (`id`, `status`, `decline_reason`, `responded_at`, `meeting_id`, `member_id`) VALUES
(2357, 'accepted', NULL, '2026-08-25 10:32:06.624151', 619, 1486),
(2358, 'accepted', NULL, '2026-08-25 10:32:06.625131', 619, 1487),
(2359, 'pending', NULL, NULL, 619, 1489),
(2360, 'declined', 'Bận công tác tại quận', '2026-08-25 10:32:06.626713', 619, 1490),
(2361, 'pending', NULL, NULL, 619, 1491),
(2362, 'accepted', NULL, '2026-08-25 10:32:06.634244', 620, 1486),
(2363, 'accepted', NULL, '2026-08-25 10:32:06.635038', 620, 1488),
(2364, 'pending', NULL, NULL, 620, 1507),
(2365, 'accepted', NULL, '2026-08-25 10:32:06.639655', 621, 1486),
(2366, 'accepted', NULL, '2026-08-25 10:32:06.640520', 621, 1487),
(2367, 'accepted', NULL, '2026-08-25 10:32:06.641340', 621, 1488),
(2368, 'accepted', NULL, '2026-08-25 10:32:06.642092', 621, 1489),
(2369, 'pending', NULL, NULL, 621, 1490),
(2370, 'pending', NULL, NULL, 621, 1491),
(2371, 'pending', NULL, NULL, 621, 1507),
(2372, 'pending', NULL, NULL, 621, 1518),
(2373, 'declined', 'Trùng lịch trực trạm y tế', '2026-08-25 10:32:06.647706', 621, 1519),
(2374, 'accepted', NULL, '2026-08-25 10:32:06.663313', 622, 1486),
(2375, 'pending', NULL, NULL, 622, 1488),
(2376, 'pending', NULL, NULL, 622, 1491),
(2377, 'pending', NULL, NULL, 622, 1507),
(2378, 'pending', NULL, NULL, 622, 1513),
(2379, 'pending', NULL, NULL, 622, 1514),
(2380, 'pending', NULL, NULL, 622, 1517),
(2381, 'pending', NULL, NULL, 622, 1520),
(2382, 'pending', NULL, NULL, 623, 1490),
(2383, 'pending', NULL, NULL, 623, 1491),
(2384, 'accepted', NULL, '2026-08-25 10:32:06.689320', 624, 1486),
(2385, 'accepted', NULL, '2026-08-25 10:32:06.690104', 624, 1488),
(2386, 'accepted', NULL, '2026-08-25 10:32:06.691757', 624, 1491),
(2387, 'accepted', NULL, '2026-08-25 10:32:06.692679', 624, 1507),
(2388, 'accepted', NULL, '2026-08-25 10:32:06.701638', 625, 1491),
(2389, 'accepted', NULL, '2026-08-25 10:32:06.702527', 625, 1492),
(2390, 'pending', NULL, NULL, 625, 1507),
(2391, 'pending', NULL, NULL, 625, 1502),
(2392, 'declined', 'Đang trực bộ phận một cửa', '2026-08-25 10:32:06.704773', 625, 1493),
(2393, 'accepted', NULL, '2026-08-25 10:32:06.710215', 626, 1492),
(2394, 'accepted', NULL, '2026-08-25 10:32:06.711201', 626, 1502),
(2395, 'accepted', NULL, '2026-08-25 10:32:06.712847', 626, 1493),
(2396, 'accepted', NULL, '2026-08-25 10:32:06.716919', 627, 1502),
(2397, 'accepted', NULL, '2026-08-25 10:32:06.717666', 627, 1507),
(2398, 'pending', NULL, NULL, 628, 1486),
(2399, 'accepted', NULL, '2026-08-25 10:32:06.724420', 628, 1488),
(2400, 'pending', NULL, NULL, 628, 1489),
(2401, 'pending', NULL, NULL, 629, 1489),
(2402, 'pending', NULL, NULL, 629, 1491),
(2403, 'accepted', NULL, '2026-08-25 10:32:06.736112', 630, 1490),
(2404, 'pending', NULL, NULL, 630, 1507),
(2405, 'pending', NULL, NULL, 630, 1515),
(2406, 'accepted', NULL, '2026-08-25 10:32:06.744042', 631, 1486),
(2407, 'pending', NULL, NULL, 631, 1518),
(2408, 'pending', NULL, NULL, 632, 1489),
(2409, 'pending', NULL, NULL, 632, 1491),
(2410, 'pending', NULL, NULL, 633, 1491),
(2411, 'pending', NULL, NULL, 633, 1492),
(2412, 'pending', NULL, NULL, 634, 1507),
(2413, 'pending', NULL, NULL, 634, 1502),
(2414, 'accepted', NULL, '2026-08-25 10:32:06.766386', 635, 1488),
(2415, 'accepted', NULL, '2026-08-25 10:32:06.767574', 635, 1517),
(2416, 'accepted', NULL, '2026-08-25 10:32:06.768679', 635, 1518),
(2417, 'accepted', NULL, '2026-08-25 10:32:06.769855', 635, 1519),
(2418, 'accepted', NULL, '2026-08-25 10:32:06.776241', 636, 1491),
(2419, 'accepted', NULL, '2026-08-25 10:32:06.777250', 636, 1492),
(2420, 'accepted', NULL, '2026-08-25 10:32:06.778881', 636, 1493),
(2421, 'accepted', NULL, '2026-08-25 10:32:06.780213', 636, 1494),
(2422, 'declined', 'Nghỉ phép', '2026-08-25 10:32:06.781333', 636, 1495);

-- --------------------------------------------------------

--
-- Table structure for table `meeting_files`
--

CREATE TABLE `meeting_files` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `size_bytes` bigint(20) DEFAULT NULL,
  `kind` varchar(10) NOT NULL,
  `uploaded_at` datetime(6) NOT NULL,
  `meeting_id` bigint(20) NOT NULL,
  `file` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `meeting_files`
--

INSERT INTO `meeting_files` (`id`, `name`, `size_bytes`, `kind`, `uploaded_at`, `meeting_id`, `file`) VALUES
(50, 'Chuong_trinh_ky_hop.txt', 162, 'other', '2026-08-25 10:32:06.660589', 621, 'meeting_files/2026/08/Chuong_trinh_ky_hop_ZXTvBVV.txt'),
(51, 'Bao_cao_6_thang.txt', 159, 'other', '2026-08-25 10:32:06.699463', 624, 'meeting_files/2026/08/Bao_cao_6_thang_hSF1oR0.txt');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` bigint(20) NOT NULL,
  `name` varchar(150) NOT NULL,
  `title` varchar(150) NOT NULL,
  `unit` varchar(150) NOT NULL,
  `initials` varchar(10) NOT NULL,
  `color` varchar(10) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `name`, `title`, `unit`, `initials`, `color`, `phone`, `email`, `created_at`) VALUES
(1486, 'Nguyễn Duy An', 'Bí thư Đảng ủy - Chủ tịch HĐND phường', 'Ban lãnh đạo phường', 'DA', 'blue', NULL, 'nguyen.duy.an@caungolanh.gov.vn', '2026-08-25 10:31:42.331777'),
(1487, 'Đỗ Phương Lợi', 'Phó Chủ tịch HĐND phường', 'Ban lãnh đạo phường', 'PL', 'blue', NULL, 'do.phuong.loi@caungolanh.gov.vn', '2026-08-25 10:31:42.332896'),
(1488, 'Bồ Kỹ Thuật', 'Chủ tịch UBND phường', 'Ban lãnh đạo phường', 'KT', 'blue', NULL, 'bo.ky.thuat@caungolanh.gov.vn', '2026-08-25 10:31:42.333795'),
(1489, 'Đinh Vũ Thắng', 'Phó Chủ tịch UBND phường', 'Ban lãnh đạo phường', 'VT', 'blue', NULL, 'dinh.vu.thang@caungolanh.gov.vn', '2026-08-25 10:31:42.334709'),
(1490, 'Thái Thị Kim Thanh', 'Phó Chủ tịch UBND phường', 'Ban lãnh đạo phường', 'KT', 'blue', NULL, 'thai.thi.kim.thanh@caungolanh.gov.vn', '2026-08-25 10:31:42.335695'),
(1491, 'Dư Quang Nghĩa', 'Chánh Văn phòng', 'Văn phòng HĐND-UBND', 'QN', 'green', NULL, 'du.quang.nghia@caungolanh.gov.vn', '2026-08-25 10:31:42.337184'),
(1492, 'Nguyễn Duy Toán', 'Phó Chánh Văn phòng', 'Văn phòng HĐND-UBND', 'DT', 'green', NULL, 'nguyen.duy.toan@caungolanh.gov.vn', '2026-08-25 10:31:42.338340'),
(1493, 'Phạm Thái Hoàng', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'TH', 'green', NULL, 'pham.thai.hoang@caungolanh.gov.vn', '2026-08-25 10:31:42.339237'),
(1494, 'Huỳnh Thiên Ái Na', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'ÁN', 'green', NULL, 'huynh.thien.ai.na@caungolanh.gov.vn', '2026-08-25 10:31:42.340116'),
(1495, 'Trương Bích Tuyền', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'BT', 'green', NULL, 'truong.bich.tuyen@caungolanh.gov.vn', '2026-08-25 10:31:42.341171'),
(1496, 'Trần Nguyễn Minh Huyền', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'MH', 'green', NULL, 'tran.nguyen.minh.huyen@caungolanh.gov.vn', '2026-08-25 10:31:42.342154'),
(1497, 'Nguyễn Thanh Thủy', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'TT', 'green', NULL, 'nguyen.thanh.thuy@caungolanh.gov.vn', '2026-08-25 10:31:42.343181'),
(1498, 'Nguyễn Võ Thị Ngọc Huyền', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'NH', 'green', NULL, 'nguyen.vo.thi.ngoc.huyen@caungolanh.gov.vn', '2026-08-25 10:31:42.344032'),
(1499, 'Nguyễn Thị Hồng Hạnh', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'HH', 'green', NULL, 'nguyen.thi.hong.hanh@caungolanh.gov.vn', '2026-08-25 10:31:42.345466'),
(1500, 'Đào Công Trung', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'CT', 'green', NULL, 'dao.cong.trung@caungolanh.gov.vn', '2026-08-25 10:31:42.346785'),
(1501, 'Nguyễn Thụy Mai Huyền', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'MH', 'green', NULL, 'nguyen.thuy.mai.huyen@caungolanh.gov.vn', '2026-08-25 10:31:42.347754'),
(1502, 'Nguyễn Minh Thanh', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'MT', 'green', NULL, 'nguyen.minh.thanh@caungolanh.gov.vn', '2026-08-25 10:31:42.348625'),
(1503, 'Huỳnh Minh Tú', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'MT', 'green', NULL, 'huynh.minh.tu@caungolanh.gov.vn', '2026-08-25 10:31:42.349473'),
(1504, 'Trần Thanh Sơn', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'TS', 'green', NULL, 'tran.thanh.son@caungolanh.gov.vn', '2026-08-25 10:31:42.350204'),
(1505, 'Huỳnh Thanh Phong', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'TP', 'green', NULL, 'huynh.thanh.phong@caungolanh.gov.vn', '2026-08-25 10:31:42.350917'),
(1506, 'Hồ Minh Hoàng', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'MH', 'green', NULL, 'ho.minh.hoang@caungolanh.gov.vn', '2026-08-25 10:31:42.351863'),
(1507, 'Nguyễn Thị Ngọc Hân', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'NH', 'green', NULL, 'nguyen.thi.ngoc.han@caungolanh.gov.vn', '2026-08-25 10:31:42.352797'),
(1508, 'Lại Xuân Sự', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'XS', 'green', NULL, 'lai.xuan.su@caungolanh.gov.vn', '2026-08-25 10:31:42.353572'),
(1509, 'Đoàn Tuấn Anh', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'TA', 'green', NULL, 'doan.tuan.anh@caungolanh.gov.vn', '2026-08-25 10:31:42.354305'),
(1510, 'Trần Hoài Nam Long', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'NL', 'green', NULL, 'tran.hoai.nam.long@caungolanh.gov.vn', '2026-08-25 10:31:42.355013'),
(1511, 'Thái Huy', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'TH', 'green', NULL, 'thai.huy@caungolanh.gov.vn', '2026-08-25 10:31:42.355754'),
(1512, 'Lương Trần Thiên Phúc', 'Chuyên viên', 'Văn phòng HĐND-UBND', 'TP', 'green', NULL, 'luong.tran.thien.phuc@caungolanh.gov.vn', '2026-08-25 10:31:42.356442'),
(1513, 'Đại diện Phòng Văn hóa - Xã hội', 'Văn thư / đại diện đơn vị', 'Phòng Văn hóa - Xã hội', 'XH', 'amber', NULL, 'dai.dien.phong.van.hoa.-.xa.hoi@caungolanh.gov.vn', '2026-08-25 10:31:42.357161'),
(1514, 'Đại diện Phòng Kinh tế, Hạ tầng và Đô thị', 'Văn thư / đại diện đơn vị', 'Phòng Kinh tế, Hạ tầng và Đô thị', 'ĐT', 'amber', NULL, 'dai.dien.phong.kinh.te,.ha.tang.va.do.thi@caungolanh.gov.vn', '2026-08-25 10:31:42.358052'),
(1515, 'Đại diện Trung tâm phục vụ HCC', 'Văn thư / đại diện đơn vị', 'Trung tâm phục vụ hành chính công', 'VH', 'amber', NULL, 'dai.dien.trung.tam.phuc.vu.hcc@caungolanh.gov.vn', '2026-08-25 10:31:42.358773'),
(1516, 'Đại diện Trung tâm cung ứng DVC', 'Văn thư / đại diện đơn vị', 'Trung tâm cung ứng dịch vụ công', 'ỨD', 'amber', NULL, 'dai.dien.trung.tam.cung.ung.dvc@caungolanh.gov.vn', '2026-08-25 10:31:42.359485'),
(1517, 'Đại diện Ban CH Quân sự', 'Văn thư / đại diện đơn vị', 'Ban Chỉ huy quân sự', 'QS', 'amber', NULL, 'dai.dien.ban.ch.quan.su@caungolanh.gov.vn', '2026-08-25 10:31:42.360186'),
(1518, 'Đại diện Ban CH Công an', 'Văn thư / đại diện đơn vị', 'Ban Chỉ huy công an', 'CA', 'amber', NULL, 'dai.dien.ban.ch.cong.an@caungolanh.gov.vn', '2026-08-25 10:31:42.361066'),
(1519, 'Đại diện Trạm Y tế', 'Văn thư / đại diện đơn vị', 'Trạm y tế', 'YT', 'amber', NULL, 'dai.dien.tram.y.te@caungolanh.gov.vn', '2026-08-25 10:31:42.362907'),
(1520, 'Nguyễn Văn Khách', 'Khách mời', 'Khác', 'VK', 'amber', NULL, 'nguyen.van.khach@caungolanh.gov.vn', '2026-08-25 10:31:42.363856'),
(1521, 'Đại diện Trường Tiểu học Nguyễn Thái Học', 'Khách mời', 'Khác', 'TH', 'amber', NULL, 'dai.dien.truong.tieu.hoc.nguyen.thai.hoc@caungolanh.gov.vn', '2026-08-25 10:31:42.364618'),
(1522, 'ngô đình hoàng', 'Khác', 'Khác', 'HĐ', 'amber', NULL, NULL, '2026-08-25 10:34:30.641546'),
(1523, 'lê tui', 'Khác', 'Khác', 'TL', 'amber', NULL, NULL, '2026-08-25 10:35:06.807172');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` varchar(500) NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `meeting_id` bigint(20) DEFAULT NULL,
  `recipient_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `title`, `message`, `is_read`, `created_at`, `meeting_id`, `recipient_id`) VALUES
(6024, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805689', 619, 76),
(6025, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805719', 619, 542),
(6026, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805732', 619, 543),
(6027, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805742', 619, 544),
(6028, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805752', 619, 545),
(6029, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805763', 619, 546),
(6030, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805773', 619, 547),
(6031, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805783', 619, 548),
(6032, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805792', 619, 549),
(6033, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805802', 619, 550),
(6034, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805812', 619, 551),
(6035, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805823', 619, 552),
(6036, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805832', 619, 553),
(6037, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805842', 619, 554),
(6038, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805851', 619, 555),
(6039, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805861', 619, 556),
(6040, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805871', 619, 557),
(6041, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805881', 619, 558),
(6042, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805891', 619, 559),
(6043, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805900', 619, 560),
(6044, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805910', 619, 561),
(6045, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805920', 619, 562),
(6046, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805930', 619, 563),
(6047, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805940', 619, 564),
(6048, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805950', 619, 565),
(6049, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805959', 619, 566),
(6050, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805969', 619, 567),
(6051, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805979', 619, 568),
(6052, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805988', 619, 569),
(6053, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.805998', 619, 570),
(6054, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806007', 619, 571),
(6055, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806017', 619, 572),
(6056, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806028', 619, 573),
(6057, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806038', 619, 574),
(6058, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806049', 619, 575),
(6059, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806059', 619, 576),
(6060, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806068', 619, 577),
(6061, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806078', 619, 578),
(6062, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806088', 619, 579),
(6063, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806097', 619, 580),
(6064, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806107', 619, 581),
(6065, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806117', 619, 582),
(6066, 'Lịch họp mới', '\"Họp giao ban tuần\" — 28/08/2026 · 08:00', 0, '2026-08-25 10:32:06.806127', 619, 583),
(6067, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806136', 620, 76),
(6068, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806146', 620, 542),
(6069, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806156', 620, 543),
(6070, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806165', 620, 544),
(6071, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806175', 620, 545),
(6072, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806184', 620, 546),
(6073, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806194', 620, 547),
(6074, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806204', 620, 548),
(6075, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806213', 620, 549),
(6076, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806223', 620, 550),
(6077, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806233', 620, 551),
(6078, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806243', 620, 552),
(6079, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806253', 620, 553),
(6080, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806263', 620, 554),
(6081, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806273', 620, 555),
(6082, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806284', 620, 556),
(6083, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806294', 620, 557),
(6084, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806303', 620, 558),
(6085, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806313', 620, 559),
(6086, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806323', 620, 560),
(6087, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806333', 620, 561),
(6088, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806342', 620, 562),
(6089, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806352', 620, 563),
(6090, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806362', 620, 564),
(6091, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806374', 620, 565),
(6092, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806384', 620, 566),
(6093, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806393', 620, 567),
(6094, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806403', 620, 568),
(6095, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806413', 620, 569),
(6096, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806422', 620, 570),
(6097, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806432', 620, 571),
(6098, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806442', 620, 572),
(6099, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806451', 620, 573),
(6100, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806461', 620, 574),
(6101, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806471', 620, 575),
(6102, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806481', 620, 576),
(6103, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806490', 620, 577),
(6104, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806500', 620, 578),
(6105, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806510', 620, 579),
(6106, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806520', 620, 580),
(6107, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806529', 620, 581),
(6108, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806538', 620, 582),
(6109, 'Lịch họp mới', '\"Làm việc với đoàn công tác Thành phố\" — 28/08/2026 · 10:00', 0, '2026-08-25 10:32:06.806549', 620, 583),
(6110, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806560', 621, 76),
(6111, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806572', 621, 542),
(6112, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806582', 621, 543),
(6113, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806592', 621, 544),
(6114, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806602', 621, 545),
(6115, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806612', 621, 546),
(6116, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806622', 621, 547),
(6117, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806632', 621, 548),
(6118, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806641', 621, 549),
(6119, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806651', 621, 550),
(6120, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806660', 621, 551),
(6121, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806670', 621, 552),
(6122, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806680', 621, 553),
(6123, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806690', 621, 554),
(6124, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806700', 621, 555),
(6125, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806709', 621, 556),
(6126, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806718', 621, 557),
(6127, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806728', 621, 558),
(6128, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806737', 621, 559),
(6129, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806751', 621, 560),
(6130, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806761', 621, 561),
(6131, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806770', 621, 562),
(6132, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806781', 621, 563),
(6133, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806791', 621, 564),
(6134, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806800', 621, 565),
(6135, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806810', 621, 566),
(6136, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806820', 621, 567),
(6137, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806829', 621, 568),
(6138, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806838', 621, 569),
(6139, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806848', 621, 570),
(6140, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806857', 621, 571),
(6141, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806866', 621, 572),
(6142, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806876', 621, 573),
(6143, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806885', 621, 574),
(6144, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806894', 621, 575),
(6145, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806903', 621, 576),
(6146, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806913', 621, 577),
(6147, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806922', 621, 578),
(6148, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806931', 621, 579),
(6149, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806940', 621, 580),
(6150, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806949', 621, 581),
(6151, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806958', 621, 582),
(6152, 'Lịch họp mới', '\"Phiên họp thường kỳ HĐND phường\" — 01/09/2026 · 08:00', 0, '2026-08-25 10:32:06.806967', 621, 583),
(6153, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.806977', 622, 76),
(6154, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.806986', 622, 542),
(6155, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.806996', 622, 543),
(6156, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807005', 622, 544),
(6157, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807014', 622, 545),
(6158, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807023', 622, 546),
(6159, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807033', 622, 547),
(6160, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807043', 622, 548),
(6161, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807052', 622, 549),
(6162, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807063', 622, 550),
(6163, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807072', 622, 551),
(6164, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807082', 622, 552),
(6165, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807091', 622, 553),
(6166, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807100', 622, 554),
(6167, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807109', 622, 555),
(6168, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807118', 622, 556),
(6169, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807127', 622, 557),
(6170, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807137', 622, 558),
(6171, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807146', 622, 559),
(6172, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807155', 622, 560),
(6173, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807165', 622, 561),
(6174, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807174', 622, 562),
(6175, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807184', 622, 563),
(6176, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807194', 622, 564),
(6177, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807203', 622, 565),
(6178, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807212', 622, 566),
(6179, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807221', 622, 567),
(6180, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807230', 622, 568),
(6181, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807239', 622, 569),
(6182, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807248', 622, 570),
(6183, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807257', 622, 571),
(6184, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807266', 622, 572),
(6185, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807275', 622, 573),
(6186, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807285', 622, 574),
(6187, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807294', 622, 575),
(6188, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807303', 622, 576),
(6189, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807312', 622, 577),
(6190, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807322', 622, 578),
(6191, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807331', 622, 579),
(6192, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807340', 622, 580),
(6193, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807351', 622, 581),
(6194, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807360', 622, 582),
(6195, 'Lịch họp mới', '\"Hội nghị triển khai kế hoạch quý 4\" — 04/09/2026 · 08:30', 0, '2026-08-25 10:32:06.807370', 622, 583),
(6196, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807380', 623, 76),
(6197, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807390', 623, 542),
(6198, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807399', 623, 543),
(6199, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807409', 623, 544),
(6200, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807419', 623, 545),
(6201, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807428', 623, 546),
(6202, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807437', 623, 547),
(6203, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807447', 623, 548),
(6204, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807456', 623, 549),
(6205, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807466', 623, 550),
(6206, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807475', 623, 551),
(6207, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807485', 623, 552),
(6208, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807494', 623, 553),
(6209, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807503', 623, 554),
(6210, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807512', 623, 555),
(6211, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807523', 623, 556),
(6212, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807532', 623, 557),
(6213, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807541', 623, 558),
(6214, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807550', 623, 559),
(6215, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807560', 623, 560),
(6216, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807569', 623, 561),
(6217, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807578', 623, 562),
(6218, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807587', 623, 563),
(6219, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807597', 623, 564),
(6220, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807606', 623, 565),
(6221, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807616', 623, 566),
(6222, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807626', 623, 567),
(6223, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807635', 623, 568),
(6224, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807645', 623, 569),
(6225, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807655', 623, 570),
(6226, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807664', 623, 571),
(6227, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807674', 623, 572),
(6228, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807683', 623, 573),
(6229, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807692', 623, 574),
(6230, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807701', 623, 575),
(6231, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807710', 623, 576),
(6232, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807719', 623, 577),
(6233, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807729', 623, 578),
(6234, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807738', 623, 579),
(6235, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807747', 623, 580),
(6236, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807756', 623, 581),
(6237, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807765', 623, 582),
(6238, 'Lịch họp mới (đã hoãn)', '\"Họp rà soát công tác tháng 8 (đã hoãn)\" — 27/08/2026 · 14:00', 0, '2026-08-25 10:32:06.807774', 623, 583),
(6239, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807784', 624, 76),
(6240, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807793', 624, 542),
(6241, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807803', 624, 543),
(6242, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807812', 624, 544),
(6243, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807821', 624, 545),
(6244, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807831', 624, 546),
(6245, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807840', 624, 547),
(6246, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807849', 624, 548),
(6247, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807859', 624, 549),
(6248, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807868', 624, 550),
(6249, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807877', 624, 551),
(6250, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807888', 624, 552),
(6251, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807898', 624, 553),
(6252, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807908', 624, 554),
(6253, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807918', 624, 555),
(6254, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807927', 624, 556),
(6255, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807937', 624, 557),
(6256, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807947', 624, 558),
(6257, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807958', 624, 559),
(6258, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807967', 624, 560),
(6259, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807976', 624, 561),
(6260, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807987', 624, 562),
(6261, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.807996', 624, 563),
(6262, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808014', 624, 564),
(6263, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808023', 624, 565),
(6264, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808033', 624, 566),
(6265, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808042', 624, 567),
(6266, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808052', 624, 568),
(6267, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808063', 624, 569),
(6268, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808072', 624, 570),
(6269, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808082', 624, 571),
(6270, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808091', 624, 572),
(6271, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808101', 624, 573),
(6272, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808110', 624, 574),
(6273, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808120', 624, 575),
(6274, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808129', 624, 576),
(6275, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808139', 624, 577),
(6276, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808149', 624, 578),
(6277, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808158', 624, 579),
(6278, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808168', 624, 580),
(6279, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808178', 624, 581),
(6280, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808187', 624, 582),
(6281, 'Lịch họp mới', '\"Tổng kết công tác 6 tháng đầu năm\" — 17/08/2026 · 08:00', 1, '2026-08-25 10:32:06.808196', 624, 583),
(6282, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808206', 625, 76),
(6283, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808215', 625, 542),
(6284, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808225', 625, 543),
(6285, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808234', 625, 544),
(6286, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808244', 625, 545),
(6287, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808254', 625, 546),
(6288, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808265', 625, 547),
(6289, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808275', 625, 548),
(6290, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808285', 625, 549),
(6291, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808295', 625, 550),
(6292, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808305', 625, 551),
(6293, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808315', 625, 552),
(6294, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808325', 625, 553),
(6295, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808335', 625, 554),
(6296, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808345', 625, 555),
(6297, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808355', 625, 556),
(6298, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808365', 625, 557),
(6299, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808375', 625, 558),
(6300, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808384', 625, 559),
(6301, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808393', 625, 560),
(6302, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808404', 625, 561),
(6303, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808413', 625, 562),
(6304, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808423', 625, 563),
(6305, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808433', 625, 564),
(6306, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808443', 625, 565),
(6307, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808453', 625, 566),
(6308, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808462', 625, 567),
(6309, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808477', 625, 568),
(6310, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808487', 625, 569),
(6311, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808496', 625, 570),
(6312, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808506', 625, 571),
(6313, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808516', 625, 572),
(6314, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808527', 625, 573),
(6315, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808536', 625, 574),
(6316, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808546', 625, 575),
(6317, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808556', 625, 576),
(6318, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808565', 625, 577),
(6319, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808575', 625, 578),
(6320, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808584', 625, 579),
(6321, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808594', 625, 580),
(6322, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808604', 625, 581),
(6323, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808614', 625, 582),
(6324, 'Lịch họp mới', '\"Họp giao ban Văn phòng tuần\" — 26/08/2026 · 09:00', 0, '2026-08-25 10:32:06.808623', 625, 583),
(6325, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808632', 626, 76),
(6326, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808642', 626, 542),
(6327, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808652', 626, 543),
(6328, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808661', 626, 544),
(6329, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808671', 626, 545),
(6330, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808681', 626, 546),
(6331, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808690', 626, 547),
(6332, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808701', 626, 548),
(6333, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808711', 626, 549),
(6334, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808721', 626, 550),
(6335, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808730', 626, 551),
(6336, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808739', 626, 552),
(6337, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808751', 626, 553),
(6338, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808760', 626, 554),
(6339, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808770', 626, 555),
(6340, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808779', 626, 556),
(6341, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808789', 626, 557),
(6342, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808798', 626, 558),
(6343, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808808', 626, 559),
(6344, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808817', 626, 560),
(6345, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808828', 626, 561),
(6346, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808837', 626, 562),
(6347, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808847', 626, 563),
(6348, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808857', 626, 564),
(6349, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808866', 626, 565),
(6350, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808876', 626, 566),
(6351, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808885', 626, 567),
(6352, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808895', 626, 568),
(6353, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808904', 626, 569),
(6354, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808915', 626, 570),
(6355, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808925', 626, 571),
(6356, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808934', 626, 572),
(6357, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808944', 626, 573),
(6358, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808953', 626, 574),
(6359, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808962', 626, 575),
(6360, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808971', 626, 576),
(6361, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808981', 626, 577),
(6362, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808990', 626, 578),
(6363, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.808999', 626, 579),
(6364, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.809010', 626, 580),
(6365, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.809019', 626, 581),
(6366, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.809028', 626, 582),
(6367, 'Lịch họp mới', '\"Rà soát hồ sơ thi đua khen thưởng\" — 24/08/2026 · 09:30', 1, '2026-08-25 10:32:06.809038', 626, 583),
(6368, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809047', 627, 76),
(6369, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809057', 627, 542),
(6370, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809067', 627, 543),
(6371, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809076', 627, 544),
(6372, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809085', 627, 545),
(6373, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809094', 627, 546),
(6374, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809103', 627, 547),
(6375, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809113', 627, 548),
(6376, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809122', 627, 549),
(6377, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809132', 627, 550),
(6378, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809142', 627, 551),
(6379, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809151', 627, 552),
(6380, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809161', 627, 553),
(6381, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809171', 627, 554),
(6382, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809181', 627, 555),
(6383, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809191', 627, 556),
(6384, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809201', 627, 557),
(6385, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809211', 627, 558),
(6386, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809220', 627, 559),
(6387, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809230', 627, 560),
(6388, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809239', 627, 561),
(6389, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809248', 627, 562),
(6390, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809257', 627, 563),
(6391, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809267', 627, 564),
(6392, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809277', 627, 565),
(6393, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809286', 627, 566),
(6394, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809296', 627, 567),
(6395, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809305', 627, 568),
(6396, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809314', 627, 569),
(6397, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809324', 627, 570),
(6398, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809334', 627, 571),
(6399, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809344', 627, 572),
(6400, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809353', 627, 573),
(6401, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809362', 627, 574),
(6402, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809373', 627, 575),
(6403, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809382', 627, 576),
(6404, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809391', 627, 577),
(6405, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809400', 627, 578),
(6406, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809410', 627, 579),
(6407, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809420', 627, 580),
(6408, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809429', 627, 581),
(6409, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809438', 627, 582),
(6410, 'Lịch họp mới', '\"Trao đổi nghiệp vụ văn thư - lưu trữ\" — 10/08/2026 · 08:30', 1, '2026-08-25 10:32:06.809447', 627, 583),
(6411, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809456', 628, 76),
(6412, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809466', 628, 542),
(6413, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809475', 628, 543),
(6414, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809484', 628, 544),
(6415, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809495', 628, 545),
(6416, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809504', 628, 546),
(6417, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809514', 628, 547);
INSERT INTO `notifications` (`id`, `title`, `message`, `is_read`, `created_at`, `meeting_id`, `recipient_id`) VALUES
(6418, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809523', 628, 548),
(6419, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809532', 628, 549),
(6420, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809542', 628, 550),
(6421, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809551', 628, 551),
(6422, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809560', 628, 552),
(6423, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809570', 628, 553),
(6424, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809580', 628, 554),
(6425, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809590', 628, 555),
(6426, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809600', 628, 556),
(6427, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809609', 628, 557),
(6428, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809618', 628, 558),
(6429, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809627', 628, 559),
(6430, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809638', 628, 560),
(6431, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809647', 628, 561),
(6432, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809658', 628, 562),
(6433, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809667', 628, 563),
(6434, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809677', 628, 564),
(6435, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809686', 628, 565),
(6436, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809695', 628, 566),
(6437, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809705', 628, 567),
(6438, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809714', 628, 568),
(6439, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809723', 628, 569),
(6440, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809732', 628, 570),
(6441, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809741', 628, 571),
(6442, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809751', 628, 572),
(6443, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809760', 628, 573),
(6444, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809769', 628, 574),
(6445, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809778', 628, 575),
(6446, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809788', 628, 576),
(6447, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809797', 628, 577),
(6448, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809806', 628, 578),
(6449, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809815', 628, 579),
(6450, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809825', 628, 580),
(6451, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809834', 628, 581),
(6452, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809844', 628, 582),
(6453, 'Lịch họp mới', '\"Hội ý lãnh đạo đầu tuần\" — 30/08/2026 · 07:30', 0, '2026-08-25 10:32:06.809853', 628, 583),
(6454, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809862', 629, 76),
(6455, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809872', 629, 542),
(6456, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809881', 629, 543),
(6457, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809890', 629, 544),
(6458, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809900', 629, 545),
(6459, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809909', 629, 546),
(6460, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809918', 629, 547),
(6461, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809929', 629, 548),
(6462, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809938', 629, 549),
(6463, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809948', 629, 550),
(6464, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809957', 629, 551),
(6465, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809966', 629, 552),
(6466, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809976', 629, 553),
(6467, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809986', 629, 554),
(6468, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.809995', 629, 555),
(6469, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810005', 629, 556),
(6470, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810014', 629, 557),
(6471, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810023', 629, 558),
(6472, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810033', 629, 559),
(6473, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810042', 629, 560),
(6474, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810051', 629, 561),
(6475, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810060', 629, 562),
(6476, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810070', 629, 563),
(6477, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810079', 629, 564),
(6478, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810088', 629, 565),
(6479, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810097', 629, 566),
(6480, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810106', 629, 567),
(6481, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810116', 629, 568),
(6482, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810125', 629, 569),
(6483, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810134', 629, 570),
(6484, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810144', 629, 571),
(6485, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810153', 629, 572),
(6486, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810162', 629, 573),
(6487, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810172', 629, 574),
(6488, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810181', 629, 575),
(6489, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810190', 629, 576),
(6490, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810199', 629, 577),
(6491, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810208', 629, 578),
(6492, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810217', 629, 579),
(6493, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810228', 629, 580),
(6494, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810238', 629, 581),
(6495, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810247', 629, 582),
(6496, 'Lịch họp mới', '\"Trao đổi công tác nhân sự\" — 30/08/2026 · 14:00', 0, '2026-08-25 10:32:06.810256', 629, 583),
(6497, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810266', 630, 76),
(6498, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810275', 630, 542),
(6499, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810284', 630, 543),
(6500, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810293', 630, 544),
(6501, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810302', 630, 545),
(6502, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810312', 630, 546),
(6503, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810321', 630, 547),
(6504, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810330', 630, 548),
(6505, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810339', 630, 549),
(6506, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810349', 630, 550),
(6507, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810358', 630, 551),
(6508, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810367', 630, 552),
(6509, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810376', 630, 553),
(6510, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810385', 630, 554),
(6511, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810395', 630, 555),
(6512, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810404', 630, 556),
(6513, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810413', 630, 557),
(6514, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810422', 630, 558),
(6515, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810431', 630, 559),
(6516, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810442', 630, 560),
(6517, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810451', 630, 561),
(6518, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810461', 630, 562),
(6519, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810471', 630, 563),
(6520, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810480', 630, 564),
(6521, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810490', 630, 565),
(6522, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810499', 630, 566),
(6523, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810509', 630, 567),
(6524, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810519', 630, 568),
(6525, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810528', 630, 569),
(6526, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810537', 630, 570),
(6527, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810550', 630, 571),
(6528, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810559', 630, 572),
(6529, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810568', 630, 573),
(6530, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810578', 630, 574),
(6531, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810587', 630, 575),
(6532, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810596', 630, 576),
(6533, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810605', 630, 577),
(6534, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810614', 630, 578),
(6535, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810623', 630, 579),
(6536, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810632', 630, 580),
(6537, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810642', 630, 581),
(6538, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810651', 630, 582),
(6539, 'Lịch họp mới', '\"Họp chuyên đề cải cách hành chính\" — 31/08/2026 · 08:00', 0, '2026-08-25 10:32:06.810660', 630, 583),
(6540, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810669', 631, 76),
(6541, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810679', 631, 542),
(6542, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810688', 631, 543),
(6543, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810697', 631, 544),
(6544, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810707', 631, 545),
(6545, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810717', 631, 546),
(6546, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810726', 631, 547),
(6547, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810736', 631, 548),
(6548, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810745', 631, 549),
(6549, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810755', 631, 550),
(6550, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810765', 631, 551),
(6551, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810774', 631, 552),
(6552, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810783', 631, 553),
(6553, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810792', 631, 554),
(6554, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810803', 631, 555),
(6555, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810812', 631, 556),
(6556, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810822', 631, 557),
(6557, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810831', 631, 558),
(6558, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810841', 631, 559),
(6559, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810850', 631, 560),
(6560, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810859', 631, 561),
(6561, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810868', 631, 562),
(6562, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810878', 631, 563),
(6563, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810887', 631, 564),
(6564, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810897', 631, 565),
(6565, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810906', 631, 566),
(6566, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810915', 631, 567),
(6567, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810925', 631, 568),
(6568, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810935', 631, 569),
(6569, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810944', 631, 570),
(6570, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810954', 631, 571),
(6571, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810963', 631, 572),
(6572, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810972', 631, 573),
(6573, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810982', 631, 574),
(6574, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.810991', 631, 575),
(6575, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.811001', 631, 576),
(6576, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.811010', 631, 577),
(6577, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.811019', 631, 578),
(6578, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.811028', 631, 579),
(6579, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.811038', 631, 580),
(6580, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.811047', 631, 581),
(6581, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.811056', 631, 582),
(6582, 'Lịch họp mới', '\"Tiếp công dân định kỳ\" — 31/08/2026 · 08:30', 0, '2026-08-25 10:32:06.811066', 631, 583),
(6583, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811076', 634, 76),
(6584, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811089', 634, 542),
(6585, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811138', 634, 543),
(6586, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811216', 634, 544),
(6587, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811283', 634, 545),
(6588, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811326', 634, 546),
(6589, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811356', 634, 547),
(6590, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811388', 634, 548),
(6591, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811422', 634, 549),
(6592, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811454', 634, 550),
(6593, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811483', 634, 551),
(6594, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811504', 634, 552),
(6595, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811525', 634, 553),
(6596, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811547', 634, 554),
(6597, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811568', 634, 555),
(6598, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811589', 634, 556),
(6599, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811610', 634, 557),
(6600, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811631', 634, 558),
(6601, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811659', 634, 559),
(6602, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811680', 634, 560),
(6603, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811700', 634, 561),
(6604, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811720', 634, 562),
(6605, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811741', 634, 563),
(6606, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811761', 634, 564),
(6607, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811782', 634, 565),
(6608, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811804', 634, 566),
(6609, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811824', 634, 567),
(6610, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811846', 634, 568),
(6611, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811866', 634, 569),
(6612, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811886', 634, 570),
(6613, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811906', 634, 571),
(6614, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811929', 634, 572),
(6615, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811950', 634, 573),
(6616, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811971', 634, 574),
(6617, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.811992', 634, 575),
(6618, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.812002', 634, 576),
(6619, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.812025', 634, 577),
(6620, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.812038', 634, 578),
(6621, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.812051', 634, 579),
(6622, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.812064', 634, 580),
(6623, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.812076', 634, 581),
(6624, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.812089', 634, 582),
(6625, 'Lịch họp mới (đã hoãn)', '\"Họp chuyên đề văn thư lưu trữ điện tử\" — 29/08/2026 · 14:00', 0, '2026-08-25 10:32:06.812102', 634, 583),
(6626, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812116', 635, 76),
(6627, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812130', 635, 542),
(6628, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812144', 635, 543),
(6629, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812157', 635, 544),
(6630, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812171', 635, 545),
(6631, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812187', 635, 546),
(6632, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812200', 635, 547),
(6633, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812217', 635, 548),
(6634, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812234', 635, 549),
(6635, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812246', 635, 550),
(6636, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812260', 635, 551),
(6637, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812272', 635, 552),
(6638, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812282', 635, 553),
(6639, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812291', 635, 554),
(6640, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812301', 635, 555),
(6641, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812311', 635, 556),
(6642, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812321', 635, 557),
(6643, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812331', 635, 558),
(6644, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812340', 635, 559),
(6645, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812350', 635, 560),
(6646, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812364', 635, 561),
(6647, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812373', 635, 562),
(6648, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812382', 635, 563),
(6649, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812392', 635, 564),
(6650, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812402', 635, 565),
(6651, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812411', 635, 566),
(6652, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812421', 635, 567),
(6653, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812432', 635, 568),
(6654, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812441', 635, 569),
(6655, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812451', 635, 570),
(6656, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812460', 635, 571),
(6657, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812469', 635, 572),
(6658, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812479', 635, 573),
(6659, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812488', 635, 574),
(6660, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812498', 635, 575),
(6661, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812507', 635, 576),
(6662, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812517', 635, 577),
(6663, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812527', 635, 578),
(6664, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812536', 635, 579),
(6665, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812546', 635, 580),
(6666, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812555', 635, 581),
(6667, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812565', 635, 582),
(6668, 'Lịch họp mới', '\"Họp Ban Chỉ đạo phòng chống thiên tai\" — 31/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812574', 635, 583),
(6669, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812584', 636, 76),
(6670, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812596', 636, 542),
(6671, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812606', 636, 543),
(6672, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812616', 636, 544),
(6673, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812625', 636, 545),
(6674, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812635', 636, 546),
(6675, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812644', 636, 547),
(6676, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812653', 636, 548),
(6677, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812665', 636, 549),
(6678, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812675', 636, 550),
(6679, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812685', 636, 551),
(6680, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812694', 636, 552),
(6681, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812704', 636, 553),
(6682, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812716', 636, 554),
(6683, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812730', 636, 555),
(6684, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812744', 636, 556),
(6685, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812757', 636, 557),
(6686, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812769', 636, 558),
(6687, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812784', 636, 559),
(6688, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812794', 636, 560),
(6689, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812803', 636, 561),
(6690, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812812', 636, 562),
(6691, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812822', 636, 563),
(6692, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812831', 636, 564),
(6693, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812840', 636, 565),
(6694, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812850', 636, 566),
(6695, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812859', 636, 567),
(6696, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812869', 636, 568),
(6697, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812882', 636, 569),
(6698, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812892', 636, 570),
(6699, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812902', 636, 571),
(6700, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812913', 636, 572),
(6701, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812923', 636, 573),
(6702, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812932', 636, 574),
(6703, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812941', 636, 575),
(6704, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812951', 636, 576),
(6705, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812960', 636, 577),
(6706, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812970', 636, 578),
(6707, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812979', 636, 579),
(6708, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.812989', 636, 580),
(6709, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.813000', 636, 581),
(6710, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.813009', 636, 582),
(6711, 'Lịch họp mới', '\"Họp giao ban Văn phòng đầu tháng\" — 26/07/2026 · 08:00', 1, '2026-08-25 10:32:06.813019', 636, 583);

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` bigint(20) NOT NULL,
  `name` varchar(150) NOT NULL,
  `location` varchar(150) NOT NULL,
  `capacity` int(11) NOT NULL,
  `equipment` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `location`, `capacity`, `equipment`, `created_at`) VALUES
(185, 'Phòng Chủ tịch', 'Trụ sở UBND Phường', 10, NULL, '2026-08-25 10:31:42.323121'),
(186, 'Phòng họp lầu 1', 'Lầu 1', 20, NULL, '2026-08-25 10:31:42.324196'),
(187, 'Phòng họp lầu 2', 'Lầu 2', 15, NULL, '2026-08-25 10:31:42.325021'),
(188, 'Hội trường lầu 3', 'Lầu 3', 70, 'Máy chiếu, âm thanh', '2026-08-25 10:31:42.325945');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `email` varchar(254) NOT NULL,
  `role` varchar(20) NOT NULL,
  `display_name` varchar(150) NOT NULL,
  `unit` varchar(150) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `can_manage_rooms` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`, `email`, `role`, `display_name`, `unit`, `member_id`, `can_manage_rooms`) VALUES
(76, 'pbkdf2_sha256$1000000$f4b7gY0FW4KyKAKklh3Tn2$g8Ry9tFj3tyzqCepkmi85rBDZ/lwR9HcwsMD2cjB+c0=', '2026-08-24 09:53:55.957208', 1, 'admin', '', '', 1, 1, '2026-08-24 08:49:36.562562', 'admin@caungolanh.gov.vn', '', '', NULL, NULL, 0),
(542, 'pbkdf2_sha256$1000000$PdGWYF1ZpXuZ0sQILL7kOF$3ooLk5g4rYF735UXWfrDrte3cMOAYVGRg0jcpxQpXZ8=', NULL, 0, 'superadmin@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:42.365343', 'superadmin@caungolanh.gov.vn', 'quan_tri', 'Dư Quang Nghĩa', 'Văn phòng HĐND-UBND', 1491, 0),
(543, 'pbkdf2_sha256$1000000$rP7mHDyuD52qWsqhfeoLwT$ZnxaDJzCtc4YQzxJQfWwRMUuW31KhcUOvBdEy/3NamI=', NULL, 0, 'namlong@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:42.930830', 'namlong@caungolanh.gov.vn', 'quan_tri', 'Trần Hoài Nam Long', 'Văn phòng HĐND-UBND', 1510, 0),
(544, 'pbkdf2_sha256$1000000$lfJ9wHIUKrCUUxs4SnYV6A$sf8yfle/ahujgBPsllfWTNSbQ/WM0GNH0GuVOq5rGtQ=', NULL, 0, 'vanthu.ubnd@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:43.504097', 'vanthu.ubnd@caungolanh.gov.vn', 'van_thu', 'Nguyễn Thị Ngọc Hân', 'Văn phòng HĐND-UBND', 1507, 0),
(545, 'pbkdf2_sha256$1000000$uLQpLNWaHCwS6a8jX7dcLg$OPxWRjJ0uYxQsF/Q0ReEERig6qnJO9gmsyiJkCUz2+I=', NULL, 0, 'vanthu.vanphong@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:44.121577', 'vanthu.vanphong@caungolanh.gov.vn', 'phong_ban', 'Nguyễn Minh Thanh', 'Văn phòng HĐND-UBND', 1502, 0),
(546, 'pbkdf2_sha256$1000000$oLPbXADGPPTJ7pAIQXlnfE$Cvi2Ceti3shqrmmy7cZuKVgm7+1ktcBTYEFvxkyQUY4=', NULL, 0, 'lanhdao@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:44.711227', 'lanhdao@caungolanh.gov.vn', 'lanh_dao', 'Bồ Kỹ Thuật', 'Ban lãnh đạo phường', 1488, 0),
(547, 'pbkdf2_sha256$1000000$oWKGBTpvvObLQH6gVrDLCm$KcSOS/JuhLQMf/t4TLqTiVp7EyL+LATyJv/dMB/69uM=', NULL, 0, 'canbo@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:45.275699', 'canbo@caungolanh.gov.vn', 'thanh_vien', 'Phạm Thái Hoàng', 'Văn phòng HĐND-UBND', 1493, 0),
(548, 'pbkdf2_sha256$1000000$UnF4WObuNe6Ov2JT0UPHq1$X0YdAEL8HcK4yyEdIv5O2jBSlMjsUnhQgoHhKZgfuPw=', NULL, 0, 'congan@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:45.852495', 'congan@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Ban CH Công an', 'Ban Chỉ huy công an', 1518, 0),
(549, 'pbkdf2_sha256$1000000$nm5VVw3NGgGmORs9Qr5HRv$9Fl+Ubxn0zmHIKz7w3Ky1+sB7zs/k3eEFWhfDkiItaw=', NULL, 0, 'yte@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:46.421467', 'yte@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Trạm Y tế', 'Trạm y tế', 1519, 0),
(550, 'pbkdf2_sha256$1000000$o4XEIvlC3Qws1mzB5gwkMJ$bw4XTeGleRwN+NuJ6Ld1lYhF1s1dmGD6dLRuI1a2FKI=', NULL, 0, 'nguyen.duy.an@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:46.992757', 'nguyen.duy.an@caungolanh.gov.vn', 'lanh_dao', 'Nguyễn Duy An', 'Ban lãnh đạo phường', 1486, 0),
(551, 'pbkdf2_sha256$1000000$IANheCQ3kkn6Pq8bDx0ylT$Ma0M2veIkBeMEAfpqnp9SQbFP20Jg/+tbmNaLGVElTU=', NULL, 0, 'do.phuong.loi@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:47.553454', 'do.phuong.loi@caungolanh.gov.vn', 'lanh_dao', 'Đỗ Phương Lợi', 'Ban lãnh đạo phường', 1487, 0),
(552, 'pbkdf2_sha256$1000000$VGKNnEAd17KyW5uY2KkTNT$DzOrEO+cY2/qMwlG8jDCCwNxcdaHck9l5OOCddlESRA=', NULL, 0, 'bo.ky.thuat@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:48.136286', 'bo.ky.thuat@caungolanh.gov.vn', 'lanh_dao', 'Bồ Kỹ Thuật', 'Ban lãnh đạo phường', 1488, 0),
(553, 'pbkdf2_sha256$1000000$HcODjS02qYD39z1KeEK69Y$aYK0i6mixAYtjuD8WF9RqpUzHda2/QZfv9tSzKdDRAU=', NULL, 0, 'dinh.vu.thang@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:48.713654', 'dinh.vu.thang@caungolanh.gov.vn', 'lanh_dao', 'Đinh Vũ Thắng', 'Ban lãnh đạo phường', 1489, 0),
(554, 'pbkdf2_sha256$1000000$HbQf1PIGdzcvHzBdNxzWUG$n4N8KUFB/gh/1me2m4WoWMM2il9JVZCA910LZYsSYlU=', NULL, 0, 'thai.thi.kim.thanh@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:49.295079', 'thai.thi.kim.thanh@caungolanh.gov.vn', 'lanh_dao', 'Thái Thị Kim Thanh', 'Ban lãnh đạo phường', 1490, 0),
(555, 'pbkdf2_sha256$1000000$i0tTZVN9ocrnEFCxfkMpR0$WhWX/wewgcautJDPEQwOfxDmjOLseFkZMoFVE68D0dU=', NULL, 0, 'du.quang.nghia@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:49.867995', 'du.quang.nghia@caungolanh.gov.vn', 'quan_tri', 'Dư Quang Nghĩa', 'Văn phòng HĐND-UBND', 1491, 0),
(556, 'pbkdf2_sha256$1000000$UqJzwx2PTeVUB9TtfeLkA6$wjfeoUfJppgbUha57tPKk/AUcFXA7YEpACgYfdhJJNA=', NULL, 0, 'nguyen.duy.toan@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:50.449798', 'nguyen.duy.toan@caungolanh.gov.vn', 'thanh_vien', 'Nguyễn Duy Toán', 'Văn phòng HĐND-UBND', 1492, 0),
(557, 'pbkdf2_sha256$1000000$YhUeZpgIwfNFGGVhVNBpGa$7V/8F+Pg1/JJq04K5jEnJvBhLuNSIsTO8UpET7Bevug=', NULL, 0, 'pham.thai.hoang@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:51.028966', 'pham.thai.hoang@caungolanh.gov.vn', 'thanh_vien', 'Phạm Thái Hoàng', 'Văn phòng HĐND-UBND', 1493, 0),
(558, 'pbkdf2_sha256$1000000$gAdAJwO6CMwl0sJg7AwFRj$T5kGo1g6mycgAE5RKIARFCv1599NO+KbR2lXLqKNQDY=', NULL, 0, 'huynh.thien.ai.na@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:51.599197', 'huynh.thien.ai.na@caungolanh.gov.vn', 'thanh_vien', 'Huỳnh Thiên Ái Na', 'Văn phòng HĐND-UBND', 1494, 0),
(559, 'pbkdf2_sha256$1000000$Y2aza8Zu1ZO3p756gsjoPl$r7b4OahHKGTjz348iUpw3J0WGh7G6K6C+MaQxoaKwFE=', NULL, 0, 'truong.bich.tuyen@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:52.201074', 'truong.bich.tuyen@caungolanh.gov.vn', 'thanh_vien', 'Trương Bích Tuyền', 'Văn phòng HĐND-UBND', 1495, 0),
(560, 'pbkdf2_sha256$1000000$jHT1v18qQSw4dHlcaNRbqk$geJUOxAEoPxf/7mdi0Sm3/kAwxcvdFu+y4wgT0Wpb1c=', NULL, 0, 'tran.nguyen.minh.huyen@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:52.804937', 'tran.nguyen.minh.huyen@caungolanh.gov.vn', 'thanh_vien', 'Trần Nguyễn Minh Huyền', 'Văn phòng HĐND-UBND', 1496, 0),
(561, 'pbkdf2_sha256$1000000$T3hLRMRYfdolbDNw7Fbt56$zD8vZiS59avlEoFwLOvCOSQBj+MrRMq4bPD/Aylb0FY=', NULL, 0, 'nguyen.thanh.thuy@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:53.385494', 'nguyen.thanh.thuy@caungolanh.gov.vn', 'thanh_vien', 'Nguyễn Thanh Thủy', 'Văn phòng HĐND-UBND', 1497, 0),
(562, 'pbkdf2_sha256$1000000$CsrObJk8pqr60O79AOY36t$cHoBnUcTOuCv6amL0JpxXkzEVH2Gge0y1FcUfk6e4NM=', NULL, 0, 'nguyen.vo.thi.ngoc.huyen@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:53.952333', 'nguyen.vo.thi.ngoc.huyen@caungolanh.gov.vn', 'thanh_vien', 'Nguyễn Võ Thị Ngọc Huyền', 'Văn phòng HĐND-UBND', 1498, 0),
(563, 'pbkdf2_sha256$1000000$OxuQAeu2063h7ep2vOpOSN$ysnbR+sMfOog7h7IYophknbHXr8Z846n/SzwlAO7bu0=', NULL, 0, 'nguyen.thi.hong.hanh@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:54.523336', 'nguyen.thi.hong.hanh@caungolanh.gov.vn', 'thanh_vien', 'Nguyễn Thị Hồng Hạnh', 'Văn phòng HĐND-UBND', 1499, 0),
(564, 'pbkdf2_sha256$1000000$pA15X77yyoplIyeEz34nW2$UGrNimPGpeDWQZLvS1x0d64O/KrwIDvzC1UWcGA3gwg=', NULL, 0, 'dao.cong.trung@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:55.086415', 'dao.cong.trung@caungolanh.gov.vn', 'thanh_vien', 'Đào Công Trung', 'Văn phòng HĐND-UBND', 1500, 0),
(565, 'pbkdf2_sha256$1000000$2NxvwnYLyj6qFjiX86IE9q$DWO1TUFn48r79Y01iqu1TXsBDZcwui4Vx2BLCwbI0jY=', NULL, 0, 'nguyen.thuy.mai.huyen@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:55.656287', 'nguyen.thuy.mai.huyen@caungolanh.gov.vn', 'thanh_vien', 'Nguyễn Thụy Mai Huyền', 'Văn phòng HĐND-UBND', 1501, 0),
(566, 'pbkdf2_sha256$1000000$u4cA51qnLQzW1rsGgImXyO$+6rAfIJSalw6RqqcmKMqE9Nzb1q7wnEDDq3mbqTamso=', NULL, 0, 'nguyen.minh.thanh@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:56.224448', 'nguyen.minh.thanh@caungolanh.gov.vn', 'phong_ban', 'Nguyễn Minh Thanh', 'Văn phòng HĐND-UBND', 1502, 0),
(567, 'pbkdf2_sha256$1000000$u7aTnDYHjgKkSn6zqAycwA$purJvbOdADVOxTlG/qoVw3qiKUc2FzwST7yjxIr2O1Y=', NULL, 0, 'huynh.minh.tu@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:56.800328', 'huynh.minh.tu@caungolanh.gov.vn', 'thanh_vien', 'Huỳnh Minh Tú', 'Văn phòng HĐND-UBND', 1503, 0),
(568, 'pbkdf2_sha256$1000000$Wz76dy4Y9UiDgX56ktrKvK$aKEyDb7KQDVLw4RAyJk/W+RYMAqwfEAn3si6zSDMVI8=', NULL, 0, 'tran.thanh.son@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:57.370094', 'tran.thanh.son@caungolanh.gov.vn', 'thanh_vien', 'Trần Thanh Sơn', 'Văn phòng HĐND-UBND', 1504, 0),
(569, 'pbkdf2_sha256$1000000$LW29VpUR42Lqkn7LYtusSj$Ckh32gmIIp8/2g9g4fNwGfuXlLrsZk4LcdoGxsA5idg=', NULL, 0, 'huynh.thanh.phong@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:57.957824', 'huynh.thanh.phong@caungolanh.gov.vn', 'thanh_vien', 'Huỳnh Thanh Phong', 'Văn phòng HĐND-UBND', 1505, 0),
(570, 'pbkdf2_sha256$1000000$mX5v26ocfNdF216K4CMaMd$Cfypwqo0hgeQ/m5MMB3jXGEBEGNoIDvRRUnuCm4upQM=', NULL, 0, 'ho.minh.hoang@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:58.536208', 'ho.minh.hoang@caungolanh.gov.vn', 'thanh_vien', 'Hồ Minh Hoàng', 'Văn phòng HĐND-UBND', 1506, 0),
(571, 'pbkdf2_sha256$1000000$IHum26PocLIvgHMuO03Den$Iri3/XFEG+VjbMFPQ8c+AvbNKfsDafNRZlRf3x+GKhA=', NULL, 0, 'nguyen.thi.ngoc.han@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:59.124882', 'nguyen.thi.ngoc.han@caungolanh.gov.vn', 'van_thu', 'Nguyễn Thị Ngọc Hân', 'Văn phòng HĐND-UBND', 1507, 0),
(572, 'pbkdf2_sha256$1000000$nr2dE4HpiPSfi8Yg2XkAIA$lk4wDOwKMp3yrXKntHJRTpgigYQZ86kB+COVZnE4jLY=', NULL, 0, 'lai.xuan.su@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:31:59.691476', 'lai.xuan.su@caungolanh.gov.vn', 'thanh_vien', 'Lại Xuân Sự', 'Văn phòng HĐND-UBND', 1508, 0),
(573, 'pbkdf2_sha256$1000000$yGnCb9c5IGXFI5vBJfoUIk$uj90ZqWAUgbYFnaplZitSjvddo7bGulJJm4S2bQ9v2k=', NULL, 0, 'doan.tuan.anh@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:00.278308', 'doan.tuan.anh@caungolanh.gov.vn', 'thanh_vien', 'Đoàn Tuấn Anh', 'Văn phòng HĐND-UBND', 1509, 0),
(574, 'pbkdf2_sha256$1000000$ybSdmClPkZrQjz5LU1dFJ5$9ak1pRBGuGhSwB45l41gwjXx2vDZvB7Lk3h7nV7js88=', NULL, 0, 'tran.hoai.nam.long@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:00.854566', 'tran.hoai.nam.long@caungolanh.gov.vn', 'quan_tri', 'Trần Hoài Nam Long', 'Văn phòng HĐND-UBND', 1510, 0),
(575, 'pbkdf2_sha256$1000000$qvTH5ZQpZ7C3QK1UGuQ3wB$e3b7op2lRkg7/4HqyC6dwbW8eTiwrhCoOTM3DMIK34U=', NULL, 0, 'thai.huy@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:01.442241', 'thai.huy@caungolanh.gov.vn', 'thanh_vien', 'Thái Huy', 'Văn phòng HĐND-UBND', 1511, 0),
(576, 'pbkdf2_sha256$1000000$uMBx5gSU98R5kOT9ltcOsF$2qts206VrStLpd/UqTH0xwxyMkCAF7INcRQCGKrjhZk=', NULL, 0, 'luong.tran.thien.phuc@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:02.018692', 'luong.tran.thien.phuc@caungolanh.gov.vn', 'thanh_vien', 'Lương Trần Thiên Phúc', 'Văn phòng HĐND-UBND', 1512, 1),
(577, 'pbkdf2_sha256$1000000$yEYrVWJLrO75WbYTpXDFyw$Pzapcwa7vZoeXXyCLp0ziJNBvlY9SdYleTP9n+IuE9U=', NULL, 0, 'dai.dien.phong.van.hoa.-.xa.hoi@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:02.609915', 'dai.dien.phong.van.hoa.-.xa.hoi@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Phòng Văn hóa - Xã hội', 'Phòng Văn hóa - Xã hội', 1513, 0),
(578, 'pbkdf2_sha256$1000000$YwcxUpiLMDVt51ip2NimcA$ZXpbBjF0PUUKN/gMBrrWs5F+gCv8ISRjIUp5h8/QF0g=', NULL, 0, 'dai.dien.phong.kinh.te,.ha.tang.va.do.thi@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:03.178214', 'dai.dien.phong.kinh.te,.ha.tang.va.do.thi@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Phòng Kinh tế, Hạ tầng và Đô thị', 'Phòng Kinh tế, Hạ tầng và Đô thị', 1514, 0),
(579, 'pbkdf2_sha256$1000000$9Fz9K07QQUWOe602vZKrnU$fnmHPCEQouL7t92xm8f2P4IV9WKdRgeveXqg4GrrV0M=', NULL, 0, 'dai.dien.trung.tam.phuc.vu.hcc@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:03.750554', 'dai.dien.trung.tam.phuc.vu.hcc@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Trung tâm phục vụ HCC', 'Trung tâm phục vụ hành chính công', 1515, 0),
(580, 'pbkdf2_sha256$1000000$ALFaoV4klB3w2NR15qDCbJ$6Pw2FBMFZXDUsbD4EDVXRCe6OzrjvkyzPpX2KrTALw0=', NULL, 0, 'dai.dien.trung.tam.cung.ung.dvc@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:04.320492', 'dai.dien.trung.tam.cung.ung.dvc@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Trung tâm cung ứng DVC', 'Trung tâm cung ứng dịch vụ công', 1516, 0),
(581, 'pbkdf2_sha256$1000000$3QkcbYBGZcaABVlTm5fH7V$gMewHrlJZUOg/OYPzzeEbUDORMoBzFGtRInX06q64TE=', NULL, 0, 'dai.dien.ban.ch.quan.su@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:04.895866', 'dai.dien.ban.ch.quan.su@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Ban CH Quân sự', 'Ban Chỉ huy quân sự', 1517, 0),
(582, 'pbkdf2_sha256$1000000$FRXfB9mTBBq48AyS2QarTY$AAjVR/X9k5ipTrVogS3nNzAhaoivc3Cnx/LCO56WOhE=', NULL, 0, 'dai.dien.ban.ch.cong.an@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:05.475665', 'dai.dien.ban.ch.cong.an@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Ban CH Công an', 'Ban Chỉ huy công an', 1518, 0),
(583, 'pbkdf2_sha256$1000000$6RdbRusuHVDp8ajk9ANmNL$AvUqUueDsAf2oGP+lTL1COYbCy7vZlzmiPKk86QdQqg=', NULL, 0, 'dai.dien.tram.y.te@caungolanh.gov.vn', '', '', 0, 1, '2026-08-25 10:32:06.048702', 'dai.dien.tram.y.te@caungolanh.gov.vn', 'thanh_vien', 'Đại diện Trạm Y tế', 'Trạm y tế', 1519, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users_groups`
--

CREATE TABLE `users_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_user_permissions`
--

CREATE TABLE `users_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `checkin_records`
--
ALTER TABLE `checkin_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `checkin_records_meeting_id_member_id_b74a79fa_uniq` (`meeting_id`,`member_id`),
  ADD KEY `checkin_records_member_id_b0901e04_fk_members_id` (`member_id`);

--
-- Indexes for table `conflict_acknowledgements`
--
ALTER TABLE `conflict_acknowledgements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `conflict_acknowledgement_meeting_a_id_meeting_b_i_82944638_uniq` (`meeting_a_id`,`meeting_b_id`),
  ADD KEY `conflict_acknowledgem_acknowledged_by_id_42d6385a_fk_users_id` (`acknowledged_by_id`),
  ADD KEY `conflict_acknowledgements_meeting_b_id_1610033f_fk_meetings_id` (`meeting_b_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_users_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `meetings`
--
ALTER TABLE `meetings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meetings_created_by_id_4d7e59a9_fk_users_id` (`created_by_id`),
  ADD KEY `meetings_room_id_b08a669a_fk_rooms_id` (`room_id`);

--
-- Indexes for table `meeting_attendees`
--
ALTER TABLE `meeting_attendees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `meeting_attendees_meeting_id_member_id_2a684197_uniq` (`meeting_id`,`member_id`),
  ADD KEY `meeting_attendees_member_id_fa7a7d64_fk_members_id` (`member_id`);

--
-- Indexes for table `meeting_files`
--
ALTER TABLE `meeting_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meeting_files_meeting_id_a5fc34e9_fk_meetings_id` (`meeting_id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_meeting_id_faf7e106_fk_meetings_id` (`meeting_id`),
  ADD KEY `notifications_recipient_id_e1133bac_fk_users_id` (`recipient_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `users_member_id_15e1ad07_fk_members_id` (`member_id`);

--
-- Indexes for table `users_groups`
--
ALTER TABLE `users_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_groups_user_id_group_id_fc7788e8_uniq` (`user_id`,`group_id`),
  ADD KEY `users_groups_group_id_2f3517aa_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `users_user_permissions`
--
ALTER TABLE `users_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_user_permissions_user_id_permission_id_3b86cbdf_uniq` (`user_id`,`permission_id`),
  ADD KEY `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` (`permission_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `checkin_records`
--
ALTER TABLE `checkin_records`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2382;

--
-- AUTO_INCREMENT for table `conflict_acknowledgements`
--
ALTER TABLE `conflict_acknowledgements`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `meetings`
--
ALTER TABLE `meetings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=637;

--
-- AUTO_INCREMENT for table `meeting_attendees`
--
ALTER TABLE `meeting_attendees`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2423;

--
-- AUTO_INCREMENT for table `meeting_files`
--
ALTER TABLE `meeting_files`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1524;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6712;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=189;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=584;

--
-- AUTO_INCREMENT for table `users_groups`
--
ALTER TABLE `users_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_user_permissions`
--
ALTER TABLE `users_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `checkin_records`
--
ALTER TABLE `checkin_records`
  ADD CONSTRAINT `checkin_records_meeting_id_9a371baf_fk_meetings_id` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`),
  ADD CONSTRAINT `checkin_records_member_id_b0901e04_fk_members_id` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);

--
-- Constraints for table `conflict_acknowledgements`
--
ALTER TABLE `conflict_acknowledgements`
  ADD CONSTRAINT `conflict_acknowledgem_acknowledged_by_id_42d6385a_fk_users_id` FOREIGN KEY (`acknowledged_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `conflict_acknowledgements_meeting_a_id_2d3954ea_fk_meetings_id` FOREIGN KEY (`meeting_a_id`) REFERENCES `meetings` (`id`),
  ADD CONSTRAINT `conflict_acknowledgements_meeting_b_id_1610033f_fk_meetings_id` FOREIGN KEY (`meeting_b_id`) REFERENCES `meetings` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `meetings`
--
ALTER TABLE `meetings`
  ADD CONSTRAINT `meetings_created_by_id_4d7e59a9_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `meetings_room_id_b08a669a_fk_rooms_id` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);

--
-- Constraints for table `meeting_attendees`
--
ALTER TABLE `meeting_attendees`
  ADD CONSTRAINT `meeting_attendees_meeting_id_3592104e_fk_meetings_id` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`),
  ADD CONSTRAINT `meeting_attendees_member_id_fa7a7d64_fk_members_id` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);

--
-- Constraints for table `meeting_files`
--
ALTER TABLE `meeting_files`
  ADD CONSTRAINT `meeting_files_meeting_id_a5fc34e9_fk_meetings_id` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_meeting_id_faf7e106_fk_meetings_id` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`),
  ADD CONSTRAINT `notifications_recipient_id_e1133bac_fk_users_id` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_member_id_15e1ad07_fk_members_id` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);

--
-- Constraints for table `users_groups`
--
ALTER TABLE `users_groups`
  ADD CONSTRAINT `users_groups_group_id_2f3517aa_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `users_groups_user_id_f500bee5_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `users_user_permissions`
--
ALTER TABLE `users_user_permissions`
  ADD CONSTRAINT `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `users_user_permissions_user_id_92473840_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
