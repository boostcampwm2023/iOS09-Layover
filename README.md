# iOS09-Layover

## 프로젝트 소개

<p align="center">
    <img src="https://github.com/boostcampwm2023/iOS09-Layover/assets/46420281/525b6629-8e2e-42a1-b665-e1a9b04e17cf" width=20% />
</p>
<p align="center">
    Layover는 5초에서 60초의 짧은 영상을 위치기반으로 기록하고 공유하는 플랫폼입니다. 
</p>
    
    유저들은 지구를 여행하는 여행자가 되어 자신의 여정을 간편하고 직관적인 방식으로 기록하고, 
    
    다양한 장소들의 대한 영상을 다른 유저들과 공유하고, 감상할 수 있습니다.
    
    어디서든 간편하게 Layover를 통해 방문의 순간, 기억을 지도에 기록하고, 다양한 경험을 나눌 수 있습니다. 
    
    당신의 여정을 Layover에 쌓아가보세요!

## 문서

| 그라운드 룰                                                                           | 기획/디자인 | 템플릿 | 회의록 | ***개발일지*** |
| ------------------------------------------------------------------------------------- | ---------------- | ------ | ------ | ------ |
| ⛳️ [그라운드 룰](https://loinsir.notion.site/51835aceabde449a82b56f7c15353a98?pvs=4) | 🎨 [디자인](https://www.figma.com/file/wqUKtYD2tqY6qS0TZnw2eO/Layover-UI?type=design&mode=design&t=9Io4sVa1Q17CxICu-1)             | 🔭 [템플릿](https://loinsir.notion.site/084324b5761c4d38bfd69a102e525d97?pvs=4)|📝 [회의록](https://loinsir.notion.site/2132e55f2dfd4f83ad895aabeab41684?pvs=4)| 🛠️ [DevLog](https://loinsir.notion.site/Dev-Log-346d2f9ee4c64869a7a25d350761c4a9?pvs=4)


## 팀원 소개

<table align=center>
    <thead>
        <tr >
            <th style="text-align:center;" >🍎 김인환</th>
            <th style="text-align:center;" >🍎 안유경</th>
            <th style="text-align:center;" >🍎 황지웅</th>
            <th style="text-align:center;" >🌐 박지환</th>
            <th style="text-align:center;" >🌐 백종인</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><img width="200" src="https://github.com/boostcampwm2023/iOS09-Layover/assets/46420281/3b3d1134-79f6-4b04-8ad3-78ffbc56dec9" /> </td>
            <td><img width="200" src="https://avatars.githubusercontent.com/u/70168249?v=4" /></td>
            <td><img width="200" src="https://avatars.githubusercontent.com/u/44396392?v=4" /></td>
            <td><img width="200" src="https://avatars.githubusercontent.com/u/111403658?v=4" /></td>
            <td><img width="200" src="https://avatars.githubusercontent.com/u/75191916?v=4" /></td>
        </tr>
        <tr>
            <td><a href="https://github.com/loinsir">@loinsir</a></td>
            <td><a href="https://github.com/anyukyung">@anyukyung</a></td>
            <td><a href="https://github.com/chopmozzi">@chopmozzi</a></td>
            <td><a href="https://github.com/hw-ani">@hw-ani</a></td>
            <td><a href="https://github.com/whipbaek">@whipbaek</a></td>
        </tr>
        <tr>
            <td>환1에요,,ㅎ</td>
            <td>콩이에요,,ㅎ</td>
            <td>웅이에요,,ㅎ</td>
            <td>환2에요,,,,,,ㅎ</td>
            <td>몰?루</td>
        </tr>
        <tr>
            <td width="200"><b>Write Reasonable Code!</b><br/>이유 있는 코드를 작성하기</td>
            <td width="200"><b>🏊‍♂️ DEEP DIVE</b><br/>함께 성장하기<br/>재밌게 하기<br/>꼼꼼한 코드리뷰<br/></td>
            <td width="200"><b>🐢 기본에 충실한</b><br/>서드 파티에 의존하지 않기<br/>Swift를 이용한 기술 도전 많이 하기</td>
            <td width="200">과정을 즐기기</br>열린 자세로 학습</td>
            <td width="200">영향을 주는 사람 되기 🎱</td>
        </tr>
    </tbody>
</table>

---

## 기술스택
# iOS 

### CleanSwift + Test

- CleanSwift를 적용하면서 느낀 점 / 장단점
- `MockURLProtocol`을 이용해서 서버 API가 완성되기 전 데모 개발에 활용 이후 → 테스트 코드에 Test Double로 재활용

### AVFoundation

- 비디오 트랙만 뽑아서 추출하기
- Layover만의 커스텀 PlayerView 만들기

### Mapkit

- 어노테이션 커스텀, 오버레이

### Swift Concurrency

- TaskGroup을 이용해 병렬 다운로드 처리

### 트러블슈팅

- 메모리 누수로 인한 문제인줄 알았지만 결국 다른 문제였던 것, 어떻게 찾을 수 있었는지
- 업로드 확장자는 어떻게 처리해야 하는지

- [Dev Log에서 확인할 수 있어요!](https://www.notion.so/Dev-Log-346d2f9ee4c64869a7a25d350761c4a9?pvs=21)

# BE

### ncloud 서비스를 통한 업로드, 인코딩, 스트리밍

- object storage /vod station / cloud function

### 젠킨스와 도커를 활용한 ci/cd

### 위치기반

- 위치기반으로 데이터를 가져오기

### JWT를 이용한 인증

- JSON Web Token
- Redis

### Custom Response 설정
---

![Layover표지](https://github.com/boostcampwm2023/iOS09-Layover/assets/44396392/11befbb5-46af-4e24-b8e9-cb1378239f74)

![기획 설명](https://github.com/boostcampwm2023/iOS09-Layover/assets/44396392/0a7c7d57-c513-4dda-8d1a-4396cfaf802d)

---

