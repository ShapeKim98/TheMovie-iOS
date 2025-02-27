# The Movie
> 오늘의 유행하는 영화를 추천 받고, 좋아하는 영화를 즐겨찾기 해보세요!

## 소개
[TMDB API](https://developer.themoviedb.org/docs/getting-started) 를 활용한 영화 정보 어플리케이션입니다.

## 기능
- 프로필 닉네임, 이미지, MBTI 설정 및 수정
- 영화에 대한 좋아요 표시 기능
- 당일에 유행하는 영화 목록 조회
- 영화 검색 기능
- 영화에 대한 상세정보(줄거리, 표지, 포스터, 캐스트) 조회
- 최근 검색어 저장

나만의 프로필 설정 | 오늘 유행하는 영화 탐색 | 영화의 자세한 정보 탐색 | 영화 검색하기 | 영화 좋아요 기능
|:----------:|:----------:|:----------:|:----------:|:----------:|
![Simulator Screen Recording - iPhone 16 Pro - 2025-02-12 at 00 06 51](https://github.com/user-attachments/assets/7c2de057-906b-4ecd-9fc4-6ad349616717) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-02-12 at 00 07 44](https://github.com/user-attachments/assets/30d3f8c6-6bf1-4ae4-906e-258866e586e1) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-02-12 at 00 09 37](https://github.com/user-attachments/assets/671eb5f6-beb3-45e9-b142-6d5f264f46f9) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-02-12 at 00 10 54](https://github.com/user-attachments/assets/e3a04503-3c96-4a3b-966c-5d813265a26e) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-02-12 at 00 12 47](https://github.com/user-attachments/assets/278439e1-508a-4575-b182-6444cdb2e084)


## 기술
> `UIKit`, `MVVM`, `SnapKit`, `Kingfisher`, `Alamofire`, `GCD`
- `ViewModel`의 `Input`, `Output`을 열거형으로 정의 하고, `AsyncStream`을 활용해 내부 모델의 변화를 방출하는 자체 `Redux` 패턴 구성했습니다.
- `Redux` 패턴을 적용해 `View` - `Input` - `Model` - `Output`의 단방향 데이터 플로우를 구현함으로써, 데이터 흐름의 명료성과 예측 가능성을 확보했습니다.
- `Delegate` 패턴을 활용하여 화면 간 데이터 동기화를 구현하여, 각 화면의 정보를 실시간으로 반영함으로써 일관된 사용자 경험을 제공했습니다.
- `UIButton.ConfigurationUpdateHandler`를 정의하여 버튼의 상태에 따른 맞춤형 UI를 구현함으로써, 사용자 인터랙션에 따른 동적 변화를 제공했습니다.
- `Property Wrapper`를 통해 `UserDefaults`의 재사용성을 높이고, 저장 데이터 관리 로직을 간결하게 구성했습니다.
- `Router Pattern`과 `Generic`을 활용하여 네트워크 코드 추상화함으로써 `Alamofire` 기반 코드의 재사용성을 높였습니다.
- `Mirror` 타입을 활용하여, 네트워크 파라미터의 `Key-Value`정의에 필요한 보일러플레이트 코드를 최소화하고, key 값 변화에 유연하게 대응할 수 있도록 구성했습니다.
- `UITableView`의 `tableView(_:prefetchRowsAt:)`과 `tableView(_:willDisplay:forRowAt:)`을 이용하여 자연스러운 페이지네이션을 구현하였습니다.


## 트러블 슈팅
### `GCD`를 활용한 검색어 하이라이팅 기능 최적화
검색어 하이라이팅 기능은 사용자가 입력한 검색어를 가지고, 영화 제목 및 장르를 하나하나 탐색하는 작업을 반복하게 됩니다.

이와 같은 작업은 문자열의 길이와 표시될 영화 개수의 곱배수로 늘어나, `Main Thread`에 많은 작업을 할당하게 되며, 이는 앱의 사용성을 저하시킬 수 있습니다.

그렇기 때문에 `GCD`를 활용하여 이를 최적화 하고자 합니다.

검색어 일치 여부 탐색은 `Global Queue`에 비동기적으로 할당하고, UI 업데이트를 위해, 작업 결과의 반환이나 `UILabel` 업데이트 작업은 다시 `Main Queue`로 직렬화 하도록 코드를 구성하였습니다.
```Swift
DispatchQueue.global().async {
	let lowercasedText = NSMutableAttributedString(
		string: text.lowercased()
	)

	...

	guard matchCount != characters.count else {
		DispatchQueue.main.async {
			completion(mutableAttributedString)
		}
		return
	}

	DispatchQueue.main.async {
		completion(NSMutableAttributedString(string: text))
	}
}
```
