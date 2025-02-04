# The Movie
> 오늘의 유행하는 영화를 추천 받고, 좋아하는 영화를 즐겨찾기 해보세요!

## 소개
[TBDB API](https://developer.themoviedb.org/docs/getting-started) 를 활용한 영화 정보 어플리케이션입니다.

## 기능

나만의 프로필 설정 | 오늘 유행하는 영화 탐색 | 영화의 자세한 정보 탐색 | 영화 검색하기
|:----------:|:----------:|:----------:|:----------:|
![Simulator Screenshot - iPhone 16 Pro - 2025-02-04 at 21 35 15](https://github.com/user-attachments/assets/cda805d5-a470-48ea-a627-6901692cf8d3) | ![Simulator Screenshot - iPhone 16 Pro - 2025-02-04 at 21 41 56](https://github.com/user-attachments/assets/80280447-2b7d-4ced-bd92-bdb41c3ab7dd) | ![Simulator Screenshot - iPhone 16 Pro - 2025-02-04 at 21 39 11](https://github.com/user-attachments/assets/4cba7f71-deec-442a-aecf-435b411fbd5c) | ![Simulator Screenshot - iPhone 16 Pro - 2025-02-04 at 21 39 43](https://github.com/user-attachments/assets/db53cc3a-ab16-4b6a-9aa9-fb0050bb8f50)

## 기술
> `UIKit`, `SnapKit`, `Kingfisher`, `Alamofire`, `GCD`

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
	
	//검색어 일치 여부 판단..
	
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
