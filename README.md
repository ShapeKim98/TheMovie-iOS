# The Movie
> 오늘의 유행하는 영화를 추천 받고, 좋아하는 영화를 즐겨찾기 해보세요!

## 소개
[TBDB API](https://developer.themoviedb.org/docs/getting-started) 를 활용한 영화 정보 어플리케이션입니다.

## 기능
- 프로필 닉네임, 이미지, MBTI 설정 및 수정
- 영화에 대한 좋아요 표시 기능
- 당일에 유행하는 영화 목록 조회
- 영화 검색 기능
- 영화에 대한 상세정보(줄거리, 표지, 포스터, 캐스트) 조회

나만의 프로필 설정 | 오늘 유행하는 영화 탐색 | 영화의 자세한 정보 탐색 | 영화 검색하기
|:----------:|:----------:|:----------:|:----------:|
![Simulator Screenshot - iPhone 16 Pro - 2025-02-04 at 21 35 15](https://github.com/user-attachments/assets/cda805d5-a470-48ea-a627-6901692cf8d3) | ![Simulator Screenshot - iPhone 16 Pro - 2025-02-04 at 21 41 56](https://github.com/user-attachments/assets/80280447-2b7d-4ced-bd92-bdb41c3ab7dd) | ![Simulator Screenshot - iPhone 16 Pro - 2025-02-04 at 21 39 11](https://github.com/user-attachments/assets/4cba7f71-deec-442a-aecf-435b411fbd5c) | ![Simulator Screenshot - iPhone 16 Pro - 2025-02-04 at 21 39 43](https://github.com/user-attachments/assets/db53cc3a-ab16-4b6a-9aa9-fb0050bb8f50)

## 기술
> `UIKit`, `MVVM`, `SnapKit`, `Kingfisher`, `Alamofire`, `GCD`
- `ViewModel`의 `Input`, `Output`을 열거형으로 정의 하고, `AsyncStream`으로 내부 모델의 변화를 방출하는 자체 `Redux Pattern` 구성하였습니다.
- `Redux Pattern`을 통해 `View` - `Input` - `Model` - `Ouput`의 흐름을 따르는 단방향 데이터 플로우 구성으로, 데이터 흐름을 명확하게 하였습니다.
- `Delegate Pattern`을 통한 화면 간의 데이터 동기화를 구현하였습니다.
- `UIButton.ConfigurationUpdateHandler`를 정의하여, 버튼의 상태에 맞는 커스텀 UI 구현하였습니다.
- `Property Wrapper`를 통해 `UserDefaults`의 재사용성을 높이고, 저장 데이터 관리 로직을 간결하게 하였습니다.
- `Router Pattern`과 `Generic`을 활용한 네트워크 코드 추상화로 `Alamofire` 코드의 재사용성을 높였습니다.
- `Mirror` 타입을 활용하여, 네트워크 파라미터의 `Key-Value`를 정의하는데 드는 보일러 플레이트를 줄이고, key값 변화에 대응 할 수 있도록 구성하였습니다.
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

### 메모리 누수

### `MVVM`
