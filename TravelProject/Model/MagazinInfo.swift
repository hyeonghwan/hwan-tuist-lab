import Foundation


typealias Magazine = MagazineInfo.Magazine

struct MagazineInfo {
    
    struct Magazine {
        let title: String
        let subTitle: String
        let photoImage: String
        let date: String
        let link: String
    }
    
    static let magazine: [Magazine] = [
        Magazine(title: "유럽 여행 쇼핑 성지, OOO은 꼭 가세요!", subTitle: "유럽의 인기 쇼핑 명소 총정리", photoImage: "https://cdn.pixabay.com/photo/2016/11/22/21/57/apparel-1850804_1280.jpg", date: "241118", link: "https://triple.guide/articles/265bd919-3f75-4adc-8d5d-c5cf60201bfe"),
        Magazine(title: "현지 MZ가 알려주는 오사카 MZ 인기 스팟", subTitle: "2025 오사카 여행엔 여기!", photoImage: "https://cdn.pixabay.com/photo/2020/10/22/14/05/moon-5676124_1280.jpg", date: "250103", link: "https://triple.guide/articles/d6c5257f-4d52-4a0a-aed2-6773961ee7be"),
        Magazine(title: "2025 NEWS 해외여행, 이렇게 달라졌다!", subTitle: "알고 준비하는 2025 새 여행", photoImage: "https://cdn.pixabay.com/photo/2020/03/31/10/42/park-4987140_1280.jpg", date: "250108", link: "https://triple.guide/articles/997d84b1-25b3-4494-a400-457d1205264a"),
        Magazine(title: "소중한 연차, 이때 쓰세요! 2025 황금연휴 캘린더", subTitle: "미리 세우는 2025년 여행 계획", photoImage: "https://cdn.pixabay.com/photo/2014/02/24/18/31/meeting-273857_1280.jpg", date: "241225", link: "https://triple.guide/articles/b373b73a-f7e1-4202-932b-0d8cb188042a"),
        Magazine(title: "떠나요, 둘이서 낭만이 있는 하와이로", subTitle: "새해 첫 여행, 따듯한 하와이로!", photoImage: "https://cdn.pixabay.com/photo/2015/11/09/08/51/hawaii-1034890_1280.jpg", date: "241221", link: "https://triple.guide/articles/866cb9d0-22a6-4622-94b2-7bec5f65a87e"),
        Magazine(title: "한 달 살기의 성지, 치앙마이의 재발견", subTitle: "현지인이 말하는 치앙마이의 매력", photoImage: "https://cdn.pixabay.com/photo/2016/09/15/01/57/temple-1670926_1280.jpg", date: "241218", link: "https://triple.guide/articles/1283adcc-b9da-4e5f-ab1a-15eaa02162d8"),
        Magazine(title: "태국 여행 전 필수! 대표 음식부터 주문 꿀팁까지", subTitle: "팟타이를 더 맛있게 주문하는 방법?", photoImage: "https://cdn.pixabay.com/photo/2020/02/20/13/25/city-4864747_1280.jpg", date: "241215", link: "https://triple.guide/articles/0ac41b9d-7552-4cd0-b3c4-c1297c163ce5"),
        Magazine(title: "트리플 유저 PICK 2025 인기 장소 TOP 10", subTitle: "새롭게 등록된 BEST 스팟까지!", photoImage: "https://cdn.pixabay.com/photo/2020/11/12/16/55/road-5736078_1280.jpg", date: "241231", link: "https://triple.guide/articles/db2e37da-3a27-4969-875b-b2c443fb41a7"),
        Magazine(title: "도심에서 만나는 온천 대욕장이 있는 일본 호텔", subTitle: "가까이서 즐기는 확실한 힐링", photoImage: "https://cdn.pixabay.com/photo/2022/11/15/15/37/onsen-7594228_1280.jpg", date: "241229", link: "https://triple.guide/content/articles/c683ff41-82fc-4e18-98c7-c9176b3667e3"),
        Magazine(title: "소원을 빌어요 🙏 새해맞이 해돋이 명소 7", subTitle: "배낭톡 in 새해 해돋이", photoImage: "https://cdn.pixabay.com/photo/2017/05/09/10/59/mount-fuji-2297961_1280.jpg", date: "250101", link: "https://triple.guide/content/articles/b040047b-3186-4865-b9d5-07aef77db357"),
        Magazine(title: "크리스마스 분위기 가득! 국내 일루미네이션 명소 ✨", subTitle: "요즘 SNS에서 핫한 장소 총정리", photoImage: "https://cdn.pixabay.com/photo/2014/04/10/15/37/snowman-321034_1280.jpg", date: "250101", link: "https://triple.guide/content/articles/ca81200f-e367-4fe8-988f-2fa8d0b5c421"),
        Magazine(title: "야시장 천국 '대만 여행' 먹킷리스트", subTitle: "요즘 가장 인기 있는 메뉴는 OO", photoImage: "https://cdn.pixabay.com/photo/2017/06/11/17/03/dumplings-2392893_1280.jpg", date: "250103", link: "https://triple.guide/content/articles/69f887b0-4b87-451f-8859-82c7461858b9"),
        Magazine(title: "핑크빛 바다가 펼쳐지는 환상의 섬, 롬복", subTitle: "잊히지 않는 TV속 그곳!", photoImage: "https://cdn.pixabay.com/photo/2019/08/17/19/13/landscape-4412784_1280.jpg", date: "250101", link: "https://triple.guide/content/articles/8c4cded5-ff1e-4898-b884-c7b9f84fd5d8"),
        Magazine(title: "여행 고수가 알려주는 새벽 비행기 이용 꿀팁", subTitle: "이제 공항에서 시간 때울 걱정 끝!", photoImage: "https://cdn.pixabay.com/photo/2021/09/07/11/53/car-6603726_1280.jpg", date: "250105", link: "https://triple.guide/content/articles/791578f3-95d7-4300-a51f-6dff48db5d55"),
    ]
}
