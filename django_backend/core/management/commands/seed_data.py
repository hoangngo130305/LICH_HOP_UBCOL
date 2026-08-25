import datetime
import unicodedata
from django.core.files.base import ContentFile
from django.core.management.base import BaseCommand
from django.utils import timezone
from core.models import (
    User, Member, Room, Meeting, MeetingAttendee, CheckinRecord,
    ConflictAcknowledgement, MeetingFile, Notification,
)

PASSWORD = "admin@123"
DOMAIN = "caungolanh.gov.vn"


def slug(name: str) -> str:
    # Unicode NFKD khong tach duoc 'Đ'/'đ' thanh chu cai + dau (day la 1 ky
    # tu rieng trong bang Latin Extended-A, khong phai 'D' co dau), nen phai
    # thay tay truoc -- neu khong ten bat dau bang "Đ" (Dinh, Dao, Doan...)
    # se bi mat luon chu dau tien khi tao email.
    name = name.replace('Đ', 'D').replace('đ', 'd')
    n = unicodedata.normalize('NFKD', name).encode('ascii', 'ignore').decode('ascii')
    return n.lower().replace(' ', '.')


def initials_of(name: str) -> str:
    parts = name.split()
    return ''.join(p[0].upper() for p in parts[-2:]) if len(parts) >= 2 else name[:2].upper()


class Command(BaseCommand):
    help = "Xoa sach va tao lai du lieu THAT cua UBND Phuong Cau Ong Lanh (theo bien ban hop 22/08/2026)"

    def handle(self, *args, **options):
        self.stdout.write("Dang xoa du lieu cu...")
        Notification.objects.all().delete()
        ConflictAcknowledgement.objects.all().delete()
        MeetingFile.objects.all().delete()
        CheckinRecord.objects.all().delete()
        MeetingAttendee.objects.all().delete()
        Meeting.objects.all().delete()
        Room.objects.all().delete()
        User.objects.filter(is_superuser=False).delete()
        Member.objects.all().delete()

        today = timezone.localdate()

        def d(offset):
            return today + datetime.timedelta(days=offset)

        # ===== PHONG HOP (4 phong that) =====
        self.stdout.write("Tao phong hop...")
        rooms_data = [
            ("Phòng Chủ tịch", "Trụ sở UBND Phường", 10, None),
            ("Phòng họp lầu 1", "Lầu 1", 20, None),
            ("Phòng họp lầu 2", "Lầu 2", 15, None),
            ("Hội trường lầu 3", "Lầu 3", 70, "Máy chiếu, âm thanh"),
        ]
        rooms = {}
        for name, location, capacity, equipment in rooms_data:
            rooms[name] = Room.objects.create(
                name=name, location=location, capacity=capacity, equipment=equipment)

        # ===== 5 LANH DAO PHUONG =====
        self.stdout.write("Tao lanh dao phuong...")
        leaders_data = [
            ("Nguyễn Duy An", "Bí thư Đảng ủy - Chủ tịch HĐND phường"),
            ("Đỗ Phương Lợi", "Phó Chủ tịch HĐND phường"),
            ("Bồ Kỹ Thuật", "Chủ tịch UBND phường"),
            ("Đinh Vũ Thắng", "Phó Chủ tịch UBND phường"),
            ("Thái Thị Kim Thanh", "Phó Chủ tịch UBND phường"),
        ]
        members = {}
        for name, title in leaders_data:
            members[name] = Member.objects.create(
                name=name, title=title, unit="Ban lãnh đạo phường",
                initials=initials_of(name), color="blue",
                email=f"{slug(name)}@{DOMAIN}",
            )

        # ===== 22 CAN BO VAN PHONG HDND-UBND =====
        self.stdout.write("Tao can bo Van phong HDND-UBND...")
        VP = "Văn phòng HĐND-UBND"
        vp_staff = [
            ("Dư Quang Nghĩa", "Chánh Văn phòng"),
            ("Nguyễn Duy Toán", "Phó Chánh Văn phòng"),
            ("Phạm Thái Hoàng", "Chuyên viên"),
            ("Huỳnh Thiên Ái Na", "Chuyên viên"),
            ("Trương Bích Tuyền", "Chuyên viên"),
            ("Trần Nguyễn Minh Huyền", "Chuyên viên"),
            ("Nguyễn Thanh Thủy", "Chuyên viên"),
            ("Nguyễn Võ Thị Ngọc Huyền", "Chuyên viên"),
            ("Nguyễn Thị Hồng Hạnh", "Chuyên viên"),
            ("Đào Công Trung", "Chuyên viên"),
            ("Nguyễn Thụy Mai Huyền", "Chuyên viên"),
            ("Nguyễn Minh Thanh", "Chuyên viên"),
            ("Huỳnh Minh Tú", "Chuyên viên"),
            ("Trần Thanh Sơn", "Chuyên viên"),
            ("Huỳnh Thanh Phong", "Chuyên viên"),
            ("Hồ Minh Hoàng", "Chuyên viên"),
            ("Nguyễn Thị Ngọc Hân", "Chuyên viên"),
            ("Lại Xuân Sự", "Chuyên viên"),
            ("Đoàn Tuấn Anh", "Chuyên viên"),
            ("Trần Hoài Nam Long", "Chuyên viên"),
            ("Thái Huy", "Chuyên viên"),
            ("Lương Trần Thiên Phúc", "Chuyên viên"),
        ]
        for name, title in vp_staff:
            members[name] = Member.objects.create(
                name=name, title=title, unit=VP,
                initials=initials_of(name), color="green",
                email=f"{slug(name)}@{DOMAIN}",
            )

        # ===== DAI DIEN CAC DON VI NGOAI (khoi don vi ben ngoai) =====
        self.stdout.write("Tao dai dien cac don vi...")
        other_units = [
            ("Phòng Văn hóa - Xã hội", "Đại diện Phòng Văn hóa - Xã hội"),
            ("Phòng Kinh tế, Hạ tầng và Đô thị", "Đại diện Phòng Kinh tế, Hạ tầng và Đô thị"),
            ("Trung tâm phục vụ hành chính công", "Đại diện Trung tâm phục vụ HCC"),
            ("Trung tâm cung ứng dịch vụ công", "Đại diện Trung tâm cung ứng DVC"),
            ("Ban Chỉ huy quân sự", "Đại diện Ban CH Quân sự"),
            ("Ban Chỉ huy công an", "Đại diện Ban CH Công an"),
            ("Trạm y tế", "Đại diện Trạm Y tế"),
        ]
        for unit_name, rep_name in other_units:
            members[rep_name] = Member.objects.create(
                name=rep_name, title="Văn thư / đại diện đơn vị", unit=unit_name,
                initials=initials_of(rep_name), color="amber",
                email=f"{slug(rep_name)}@{DOMAIN}",
            )

        # ===== NGUOI DUOC MOI "KHAC" (nhap tay, khong co san trong danh ba) =====
        # Mo phong tinh nang "Khac" theo bien ban hop 22/08/2026: van thu go
        # tay them mot ca nhan/don vi phat sinh chua co trong danh sach co dinh.
        self.stdout.write("Tao thanh phan 'Khac' (nhap tay)...")
        custom_guests = [
            ("Nguyễn Văn Khách", "Khách mời", "Khác"),
            ("Đại diện Trường Tiểu học Nguyễn Thái Học", "Khách mời", "Khác"),
        ]
        for name, title, unit_name in custom_guests:
            members[name] = Member.objects.create(
                name=name, title=title, unit=unit_name,
                initials=initials_of(name), color="amber",
                email=f"{slug(name)}@{DOMAIN}",
            )

        # ===== TAI KHOAN DANG NHAP (theo 3 khoi + SuperAdmin) =====
        self.stdout.write("Tao tai khoan dang nhap...")
        accounts = [
            # (email prefix, role, display_name, unit, member_name)
            ("superadmin", "quan_tri", "Dư Quang Nghĩa", VP, "Dư Quang Nghĩa"),
            # Admin thu 2 - ngang quyen voi superadmin (yeu cau 25/08/2026):
            # excel ghi "Quan ly user: Ong Tran Hoai Nam Long".
            ("namlong", "quan_tri", "Trần Hoài Nam Long", VP, "Trần Hoài Nam Long"),
            ("vanthu.ubnd", "van_thu", "Nguyễn Thị Ngọc Hân", VP, "Nguyễn Thị Ngọc Hân"),
            ("vanthu.vanphong", "phong_ban", "Nguyễn Minh Thanh", VP, "Nguyễn Minh Thanh"),
            ("lanhdao", "lanh_dao", "Bồ Kỹ Thuật", "Ban lãnh đạo phường", "Bồ Kỹ Thuật"),
            ("canbo", "thanh_vien", "Phạm Thái Hoàng", VP, "Phạm Thái Hoàng"),
            ("congan", "thanh_vien", "Đại diện Ban CH Công an", "Ban Chỉ huy công an", "Đại diện Ban CH Công an"),
            ("yte", "thanh_vien", "Đại diện Trạm Y tế", "Trạm y tế", "Đại diện Trạm Y tế"),
        ]
        users = {}
        for prefix, role, display_name, unit, member_name in accounts:
            email = f"{prefix}@{DOMAIN}"
            users[prefix] = User.objects.create_user(
                username=email, email=email, password=PASSWORD,
                role=role, unit=unit, display_name=display_name,
                member=members.get(member_name),
            )

        # ===== TAI KHOAN RIENG CHO TUNG CAN BO (25/08/2026) =====
        # Nguoi dung yeu cau: da co du lieu trong danh ba thi phai dang nhap
        # duoc bang CHINH email that cua nguoi do -- nen o day tao them tai
        # khoan rieng (dung email that trong danh ba) cho TAT CA moi nguoi
        # (5 lanh dao, 22 can bo Van phong, 7 dai dien don vi), SONG SONG voi
        # 8 tai khoan "rut gon" (alias ngan, vd. vanthu.vanphong@) da tao o
        # tren -- 2 email cung tro ve 1 nguoi/1 Member nhung la 2 User rieng.
        #
        # Sua loi 25/08/2026: ban dau code chi tao tai khoan rieng cho ai
        # CHUA co trong danh sach 8 alias (vd. bo qua Nguyen Minh Thanh vi ba
        # da co "vanthu.vanphong@"), khien ba khong dang nhap duoc bang chinh
        # email "nguyen.minh.thanh@..." nhu nguoi dung mong doi -- gio bo han
        # che nay, luon tao ca 2, va gan dung vai tro cua ho (lay tu bang
        # accounts) thay vi mac dinh "thanh_vien" cho ca 8 nguoi nay.
        self.stdout.write("Tao tai khoan rieng cho tung can bo...")
        role_overrides = {display_name: role for _, role, display_name, _, _ in accounts}

        # excel: cot "ghi chu (lich UBND phuong)" ghi "tao phong" cho ca Nam
        # Long va Luong Tran Thien Phuc; sheet "Phan quyen" xac nhan ca hai
        # cung "Quan ly server". Nam Long da duoc nang len quan_tri ngang Du
        # Quang Nghia (yeu cau 25/08/2026). Voi Phuc, nguoi dung chon phuong
        # an hep hon: chi cap quyen tao/sua phong hop (can_manage_rooms),
        # con lich noi bo van phong van "chi xem" nhu thanh_vien binh thuong
        # (khong len phong_ban vi phong_ban co them quyen tao lich).
        ROOM_MANAGERS = {"Lương Trần Thiên Phúc"}

        def add_personal_account(name, default_role, unit):
            member = members[name]
            role = role_overrides.get(name, default_role)
            users[name] = User.objects.create_user(
                username=member.email, email=member.email, password=PASSWORD,
                role=role, unit=unit, display_name=name, member=member,
                can_manage_rooms=name in ROOM_MANAGERS,
            )

        for name, _title in leaders_data:
            add_personal_account(name, 'lanh_dao', 'Ban lãnh đạo phường')
        for name, _title in vp_staff:
            add_personal_account(name, 'thanh_vien', VP)
        for unit_name, rep_name in other_units:
            add_personal_account(rep_name, 'thanh_vien', unit_name)

        # ===== LICH HOP MAU (du lieu that + nhieu truong hop de kiem thu) =====
        self.stdout.write("Tao lich hop mau...")
        meetings_data = [
            dict(title="Họp giao ban tuần", meeting_date=d(3), start_time="08:00",
                 session="am", level="uy_ban", room="Phòng họp lầu 1", unit="Bồ Kỹ Thuật",
                 host="Bồ Kỹ Thuật", content="Bồ Kỹ Thuật: Giao ban công tác tuần.",
                 attendees=["Nguyễn Duy An", "Đỗ Phương Lợi", "Đinh Vũ Thắng", "Thái Thị Kim Thanh",
                            "Dư Quang Nghĩa"],
                 rsvp={"Nguyễn Duy An": "accepted", "Đỗ Phương Lợi": "accepted",
                       "Thái Thị Kim Thanh": ("declined", "Bận công tác tại quận")},
                 checkins={}, postponed=False, estimated_people=20),
            dict(title="Làm việc với đoàn công tác Thành phố", meeting_date=d(3), start_time="10:00",
                 session="am", level="uy_ban", room="Phòng họp lầu 1", unit="Bồ Kỹ Thuật",
                 host="Bồ Kỹ Thuật", content="Bồ Kỹ Thuật: Tiếp và làm việc với đoàn công tác Thành phố.",
                 attendees=["Nguyễn Duy An", "Bồ Kỹ Thuật", "Nguyễn Thị Ngọc Hân"],
                 rsvp={"Nguyễn Duy An": "accepted", "Bồ Kỹ Thuật": "accepted"},
                 checkins={}, postponed=False, estimated_people=12),
            dict(title="Phiên họp thường kỳ HĐND phường", meeting_date=d(7), start_time="08:00",
                 session="all_day", level="uy_ban", room="Hội trường lầu 3", unit="Nguyễn Duy An",
                 host="Nguyễn Duy An", content="Nguyễn Duy An: Phiên họp thường kỳ Hội đồng nhân dân phường.",
                 attendees=["Nguyễn Duy An", "Đỗ Phương Lợi", "Bồ Kỹ Thuật", "Đinh Vũ Thắng",
                            "Thái Thị Kim Thanh", "Dư Quang Nghĩa", "Nguyễn Thị Ngọc Hân",
                            "Đại diện Ban CH Công an", "Đại diện Trạm Y tế"],
                 rsvp={"Nguyễn Duy An": "accepted", "Đỗ Phương Lợi": "accepted", "Bồ Kỹ Thuật": "accepted",
                       "Đinh Vũ Thắng": "accepted", "Đại diện Trạm Y tế": ("declined", "Trùng lịch trực trạm y tế")},
                 checkins={}, postponed=False, estimated_people=65,
                 files=[("Chuong_trinh_ky_hop.txt",
                         "CHUONG TRINH KY HOP THUONG KY HDND PHUONG\n"
                         "1. Khai mac\n2. Bao cao tinh hinh kinh te - xa hoi\n"
                         "3. Chat van va tra loi chat van\n4. Bieu quyet cac nghi quyet\n5. Be mac")]),
            dict(title="Hội nghị triển khai kế hoạch quý 4", meeting_date=d(10), start_time="08:30",
                 session="am", level="uy_ban", room="Hội trường lầu 3", unit="Bồ Kỹ Thuật",
                 host="Bồ Kỹ Thuật", content="Bồ Kỹ Thuật: Triển khai kế hoạch công tác quý 4 tới các đơn vị.",
                 attendees=["Nguyễn Duy An", "Bồ Kỹ Thuật", "Dư Quang Nghĩa", "Nguyễn Thị Ngọc Hân",
                            "Đại diện Phòng Văn hóa - Xã hội", "Đại diện Phòng Kinh tế, Hạ tầng và Đô thị",
                            "Đại diện Ban CH Quân sự", "Nguyễn Văn Khách"],
                 rsvp={"Nguyễn Duy An": "accepted"},
                 checkins={}, postponed=False, estimated_people=45),
            dict(title="Họp rà soát công tác tháng 8 (đã hoãn)", meeting_date=d(2), start_time="14:00",
                 session="pm", level="uy_ban", room="Phòng họp lầu 2", unit="Thái Thị Kim Thanh",
                 host="Thái Thị Kim Thanh", content="Thái Thị Kim Thanh: Rà soát công tác tháng 8, dời sang tuần sau.",
                 attendees=["Thái Thị Kim Thanh", "Dư Quang Nghĩa"],
                 rsvp={}, checkins={}, postponed=True, estimated_people=8),
            dict(title="Tổng kết công tác 6 tháng đầu năm", meeting_date=d(-8), start_time="08:00",
                 session="am", level="uy_ban", room="Hội trường lầu 3", unit="Bồ Kỹ Thuật",
                 host="Bồ Kỹ Thuật", content="Bồ Kỹ Thuật: Tổng kết công tác 6 tháng đầu năm.",
                 attendees=["Nguyễn Duy An", "Bồ Kỹ Thuật", "Dư Quang Nghĩa", "Nguyễn Thị Ngọc Hân"],
                 rsvp={"Nguyễn Duy An": "accepted", "Bồ Kỹ Thuật": "accepted",
                       "Dư Quang Nghĩa": "accepted", "Nguyễn Thị Ngọc Hân": "accepted"},
                 checkins={"Nguyễn Duy An": "08:02", "Bồ Kỹ Thuật": "08:00", "Dư Quang Nghĩa": "07:57"},
                 postponed=False, estimated_people=50,
                 minutes=("BIEN BAN TOM TAT\n"
                          "Thoi gian: 08:00 - " + d(-8).strftime('%d/%m/%Y') + "\n"
                          "Chu tri: Bo Ky Thuat - Chu tich UBND phuong\n"
                          "Noi dung: Danh gia ket qua cong tac 6 thang dau nam, de ra "
                          "phuong huong nhiem vu 6 thang cuoi nam.\n"
                          "Ket luan: Thong nhat trien khai theo ke hoach da bao cao, giao "
                          "Van phong theo doi, do doc thuc hien."),
                 files=[("Bao_cao_6_thang.txt",
                         "BAO CAO KET QUA CONG TAC 6 THANG DAU NAM\n"
                         "- Hoan thanh 18/20 chi tieu de ra\n- 2 chi tieu con lai dang trien khai\n"
                         "- De xuat: bo sung nhan luc cho bo phan mot cua")]),
            dict(title="Họp giao ban Văn phòng tuần", meeting_date=d(1), start_time="09:00",
                 session="am", level="phong_ban", room=None, unit=VP,
                 location_text="Phòng họp Văn phòng",
                 host="Dư Quang Nghĩa", content="Dư Quang Nghĩa: Giao ban công tác Văn phòng trong tuần.",
                 attendees=["Dư Quang Nghĩa", "Nguyễn Duy Toán", "Nguyễn Thị Ngọc Hân", "Nguyễn Minh Thanh",
                            "Phạm Thái Hoàng"],
                 rsvp={"Dư Quang Nghĩa": "accepted", "Nguyễn Duy Toán": "accepted",
                       "Phạm Thái Hoàng": ("declined", "Đang trực bộ phận một cửa")},
                 checkins={}, postponed=False, estimated_people=12),
            dict(title="Rà soát hồ sơ thi đua khen thưởng", meeting_date=d(-1), start_time="09:30",
                 session="am", level="phong_ban", room=None, unit=VP,
                 location_text="Phòng họp Văn phòng",
                 host="Nguyễn Duy Toán", content="Nguyễn Duy Toán: Rà soát hồ sơ thi đua khen thưởng quý 3.",
                 attendees=["Nguyễn Duy Toán", "Nguyễn Minh Thanh", "Phạm Thái Hoàng"],
                 rsvp={"Nguyễn Duy Toán": "accepted", "Nguyễn Minh Thanh": "accepted",
                       "Phạm Thái Hoàng": "accepted"},
                 checkins={"Nguyễn Duy Toán": "09:28", "Phạm Thái Hoàng": "09:30"}, postponed=False,
                 estimated_people=10),
            dict(title="Trao đổi nghiệp vụ văn thư - lưu trữ", meeting_date=d(-15), start_time="08:30",
                 session="am", level="phong_ban", room=None, unit=VP,
                 location_text="Phòng họp Văn phòng",
                 host="Nguyễn Minh Thanh", content="Nguyễn Minh Thanh: Trao đổi nghiệp vụ văn thư - lưu trữ định kỳ.",
                 attendees=["Nguyễn Minh Thanh", "Nguyễn Thị Ngọc Hân"],
                 rsvp={"Nguyễn Minh Thanh": "accepted", "Nguyễn Thị Ngọc Hân": "accepted"},
                 checkins={"Nguyễn Minh Thanh": "08:31", "Nguyễn Thị Ngọc Hân": "08:29"}, postponed=False,
                 estimated_people=8,
                 minutes=("BIEN BAN TRAO DOI NGHIEP VU\n"
                          "Da thong nhat quy trinh luu tru ho so dien tu ap dung tu thang toi, "
                          "phan cong Nguyen Thi Ngoc Han chu tri huong dan cac phong ban.")),
            # --- Cap nhat them cac truong hop moi de kiem thu day du hon ---
            dict(title="Hội ý lãnh đạo đầu tuần", meeting_date=d(5), start_time="07:30",
                 session="all_day", level="uy_ban", room="Phòng Chủ tịch", unit="Bồ Kỹ Thuật",
                 host="Bồ Kỹ Thuật", content="Bồ Kỹ Thuật: Hội ý lãnh đạo đầu tuần, xuyên suốt cả ngày.",
                 attendees=["Nguyễn Duy An", "Bồ Kỹ Thuật", "Đinh Vũ Thắng"],
                 rsvp={"Bồ Kỹ Thuật": "accepted"},
                 checkins={}, postponed=False, estimated_people=6),
            dict(title="Trao đổi công tác nhân sự", meeting_date=d(5), start_time="14:00",
                 session="pm", level="uy_ban", room="Phòng Chủ tịch", unit="Đinh Vũ Thắng",
                 host="Đinh Vũ Thắng",
                 content="Đinh Vũ Thắng: Trao đổi công tác nhân sự — TRÙNG với hội ý lãnh đạo (buổi Cả ngày).",
                 attendees=["Đinh Vũ Thắng", "Dư Quang Nghĩa"],
                 rsvp={},
                 checkins={}, postponed=False, estimated_people=4),
            dict(title="Họp chuyên đề cải cách hành chính", meeting_date=d(6), start_time="08:00",
                 session="am", level="uy_ban", room="Phòng họp lầu 2", unit="Thái Thị Kim Thanh",
                 host="Thái Thị Kim Thanh", content="Thái Thị Kim Thanh: Chuyên đề cải cách hành chính quý 4.",
                 attendees=["Thái Thị Kim Thanh", "Nguyễn Thị Ngọc Hân",
                            "Đại diện Trung tâm phục vụ HCC"],
                 rsvp={"Thái Thị Kim Thanh": "accepted"},
                 checkins={}, postponed=False, estimated_people=15),
            dict(title="Tiếp công dân định kỳ", meeting_date=d(6), start_time="08:30",
                 session="am", level="uy_ban", room="Phòng họp lầu 2", unit="Nguyễn Duy An",
                 host="Nguyễn Duy An",
                 content="Nguyễn Duy An: Tiếp công dân định kỳ — trùng phòng nhưng đã được điều phối ổn thỏa.",
                 attendees=["Nguyễn Duy An", "Đại diện Ban CH Công an"],
                 rsvp={"Nguyễn Duy An": "accepted"},
                 checkins={}, postponed=False, estimated_people=6),
            dict(title="Dự kiến họp chuyên đề chuyển đổi số", meeting_date=d(12), start_time="08:00",
                 session="am", level="uy_ban", room="Hội trường lầu 3", unit="Đinh Vũ Thắng",
                 host="Đinh Vũ Thắng",
                 content="Đinh Vũ Thắng: (Nháp) Dự kiến chuyên đề chuyển đổi số, chưa công bố chính thức.",
                 attendees=["Đinh Vũ Thắng", "Dư Quang Nghĩa"],
                 rsvp={}, checkins={}, postponed=False, estimated_people=30, is_draft=True),
            dict(title="Dự kiến rà soát KPI quý 4 Văn phòng", meeting_date=d(9), start_time="09:00",
                 session="am", level="phong_ban", room=None, unit=VP,
                 location_text="Phòng họp Văn phòng",
                 host="Dư Quang Nghĩa", content="Dư Quang Nghĩa: (Nháp) Dự kiến rà soát KPI quý 4, chưa công bố.",
                 attendees=["Dư Quang Nghĩa", "Nguyễn Duy Toán"],
                 rsvp={}, checkins={}, postponed=False, estimated_people=10, is_draft=True),
            dict(title="Họp chuyên đề văn thư lưu trữ điện tử", meeting_date=d(4), start_time="14:00",
                 session="pm", level="phong_ban", room=None, unit=VP,
                 location_text="Phòng họp Văn phòng",
                 host="Nguyễn Thị Ngọc Hân",
                 content="Nguyễn Thị Ngọc Hân: Chuyên đề văn thư lưu trữ điện tử — đã hoãn, chờ lịch mới.",
                 attendees=["Nguyễn Thị Ngọc Hân", "Nguyễn Minh Thanh"],
                 rsvp={}, checkins={}, postponed=True, estimated_people=8),
            dict(title="Họp Ban Chỉ đạo phòng chống thiên tai", meeting_date=d(-25), start_time="08:00",
                 session="am", level="uy_ban", room="Hội trường lầu 3", unit="Bồ Kỹ Thuật",
                 host="Bồ Kỹ Thuật",
                 content="Bồ Kỹ Thuật: Họp Ban Chỉ đạo phòng chống thiên tai và tìm kiếm cứu nạn.",
                 attendees=["Bồ Kỹ Thuật", "Đại diện Ban CH Quân sự", "Đại diện Ban CH Công an",
                            "Đại diện Trạm Y tế"],
                 rsvp={"Bồ Kỹ Thuật": "accepted", "Đại diện Ban CH Quân sự": "accepted",
                       "Đại diện Ban CH Công an": "accepted", "Đại diện Trạm Y tế": "accepted"},
                 checkins={"Bồ Kỹ Thuật": "07:58", "Đại diện Ban CH Quân sự": "08:03",
                           "Đại diện Ban CH Công an": "08:01", "Đại diện Trạm Y tế": "08:05"},
                 postponed=False, estimated_people=20,
                 minutes=("BIEN BAN HOP BAN CHI DAO PCTT-TKCN\n"
                          "Da ra soat phuong an ung pho mua bao nam nay, phan cong truc "
                          "24/24 trong mua mua bao, thong nhat danh muc trang thiet bi can bo sung.")),
            dict(title="Họp giao ban Văn phòng đầu tháng", meeting_date=d(-30), start_time="08:00",
                 session="am", level="phong_ban", room=None, unit=VP,
                 location_text="Phòng họp Văn phòng",
                 host="Dư Quang Nghĩa", content="Dư Quang Nghĩa: Giao ban Văn phòng đầu tháng.",
                 attendees=["Dư Quang Nghĩa", "Nguyễn Duy Toán", "Phạm Thái Hoàng",
                            "Huỳnh Thiên Ái Na", "Trương Bích Tuyền"],
                 rsvp={"Dư Quang Nghĩa": "accepted", "Nguyễn Duy Toán": "accepted",
                       "Phạm Thái Hoàng": "accepted", "Huỳnh Thiên Ái Na": "accepted",
                       "Trương Bích Tuyền": ("declined", "Nghỉ phép")},
                 checkins={"Dư Quang Nghĩa": "07:55", "Nguyễn Duy Toán": "08:00",
                           "Phạm Thái Hoàng": "08:04"},
                 postponed=False, estimated_people=10),
        ]

        acknowledged_conflict_titles = ("Họp chuyên đề cải cách hành chính", "Tiếp công dân định kỳ")
        meeting_by_title = {}

        for md in meetings_data:
            is_draft = md.get("is_draft", False)
            meeting = Meeting.objects.create(
                title=md["title"], meeting_date=md["meeting_date"], start_time=md["start_time"],
                session=md["session"], level=md["level"], room=rooms.get(md["room"]) if md["room"] else None,
                location_text=md.get("location_text"),
                unit=md["unit"], host=md["host"], content=md["content"],
                estimated_people=md.get("estimated_people", 20),
                postponed=md.get("postponed", False),
                is_draft=is_draft,
                minutes=md.get("minutes", ""),
            )
            meeting_by_title[md["title"]] = meeting

            rsvp = md.get("rsvp", {})
            for name in md["attendees"]:
                entry = rsvp.get(name, "pending")
                status, decline_reason = entry if isinstance(entry, tuple) else (entry, None)
                responded_at = timezone.now() if status != "pending" else None
                MeetingAttendee.objects.create(
                    meeting=meeting, member=members[name], status=status,
                    decline_reason=decline_reason, responded_at=responded_at,
                )
            for name in md["attendees"]:
                hm = md["checkins"].get(name)
                ct = None
                if hm:
                    hh, mm = map(int, hm.split(":"))
                    ct = timezone.make_aware(datetime.datetime.combine(md["meeting_date"], datetime.time(hh, mm)))
                CheckinRecord.objects.create(meeting=meeting, member=members[name], checkin_time=ct)

            for file_name, file_text in md.get("files", []):
                mf = MeetingFile(meeting=meeting, name=file_name, kind="other")
                mf.file.save(file_name, ContentFile(file_text.encode("utf-8")), save=False)
                mf.size_bytes = len(file_text.encode("utf-8"))
                mf.save()

        # ===== XAC NHAN DA DIEU PHOI cho 1 cap lich trung mau =====
        # (QT-07) minh hoa truong hop da duoc dieu phoi xong, khong con canh
        # bao nua, song song voi cap con lai (Hoi y lanh dao / Trao doi nhan
        # su) van con canh bao de nguoi dung thay ca hai truong hop.
        self.stdout.write("Tao du lieu xac nhan da dieu phoi mau...")
        a_title, b_title = acknowledged_conflict_titles
        a, b = meeting_by_title[a_title], meeting_by_title[b_title]
        m1, m2 = sorted([a, b], key=lambda m: m.id)
        ConflictAcknowledgement.objects.create(
            meeting_a=m1, meeting_b=m2, acknowledged_by=users["superadmin"],
        )

        # ===== THONG BAO (mo phong da gui khi tao lich, theo bien ban hop
        # 22/08/2026 muc 12: gui cho TOAN BO tai khoan) =====
        self.stdout.write("Tao thong bao mau...")
        all_users = list(User.objects.all())
        notif_batch = []
        for md in meetings_data:
            if md.get("is_draft"):
                continue
            meeting = meeting_by_title[md["title"]]
            when = f"{meeting.meeting_date.strftime('%d/%m/%Y')} · {meeting.start_time}"
            is_past = md["meeting_date"] < today
            for user in all_users:
                notif_batch.append(Notification(
                    recipient=user, meeting=meeting,
                    title="Lịch họp mới" if not md.get("postponed") else "Lịch họp mới (đã hoãn)",
                    message=f'"{meeting.title}" — {when}',
                    is_read=is_past,
                ))
        Notification.objects.bulk_create(notif_batch)

        self.stdout.write(self.style.SUCCESS(
            f"Xong: {Member.objects.count()} nhan su, {Room.objects.count()} phong, "
            f"{User.objects.count()} tai khoan, {Meeting.objects.count()} lich hop "
            f"({Meeting.objects.filter(is_draft=True).count()} nhap, "
            f"{Meeting.objects.filter(postponed=True).count()} hoan), "
            f"{MeetingAttendee.objects.count()} luot moi, {CheckinRecord.objects.count()} diem danh, "
            f"{MeetingFile.objects.count()} tai lieu dinh kem, "
            f"{ConflictAcknowledgement.objects.count()} cap da dieu phoi, "
            f"{Notification.objects.count()} thong bao."
        ))
        self.stdout.write(self.style.SUCCESS(f"Mat khau chung: {PASSWORD}"))
        prefixes = {a[0] for a in accounts}
        self.stdout.write("Tai khoan rut gon (demo nhanh cho tung vai tro):")
        for prefix, role, display_name, unit, _ in accounts:
            safe_name = unicodedata.normalize('NFKD', display_name).encode('ascii', 'ignore').decode('ascii')
            self.stdout.write(f"  {prefix}@{DOMAIN}  ->  {safe_name} ({role})")
        personal = {k: v for k, v in users.items() if k not in prefixes}
        self.stdout.write(f"Tai khoan rieng cho tung can bo ({len(personal)} tai khoan, dung email that):")
        for name, user in personal.items():
            safe_name = unicodedata.normalize('NFKD', name).encode('ascii', 'ignore').decode('ascii')
            extra = " [+quan ly phong hop]" if user.can_manage_rooms else ""
            self.stdout.write(f"  {user.email}  ->  {safe_name} ({user.role}){extra}")
