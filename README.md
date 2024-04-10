

# 프로젝트 소개

![uqizlogo](https://github.com/Greeddk/UQuiz/assets/116425551/fa724db7-cde2-4b84-80ad-bf39c5102eb6)

# 스크린샷
<img width="24%" src="https://github.com/Greeddk/UQuiz/assets/116425551/b919d2e1-aa94-417c-9d3c-cef0c04a82b0"/>
<img width="24%" src="https://github.com/Greeddk/UQuiz/assets/116425551/2a971b72-8708-4bad-979f-5c78e5eb8aef"/>
<img width="24%" src="https://github.com/Greeddk/UQuiz/assets/116425551/1c4f1acd-abb9-4a5c-bfdb-0a99c24d887d"/>
<img width="24%" src="https://github.com/Greeddk/UQuiz/assets/116425551/dd4c5dcd-397c-490a-93dd-00de23261ece"/>


# 앱 소개 & 기획
## ‎UQuiz - 유저가 만드는 영화 퀴즈
<div align="center">
  <a target="_blank" href="https://apps.apple.com/kr/app/uquiz-%EC%9C%A0%EC%A0%80%EA%B0%80-%EB%A7%8C%EB%93%9C%EB%8A%94-%EC%98%81%ED%99%94-%ED%80%B4%EC%A6%88/id6479728756"><img width="300px" height="auto" src="https://github.com/DeveloperAcademy-POSTECH/MacC-Team13-SplitIt/assets/91787174/a9d5c9f2-3959-41f2-8783-dae29383f560" /></a>
  <br/>
</div>

## 기획 계기

유튜브 혹은 예능을 보면 포스터의 일부분을 보여주고 정답을 맞히는 게임을 하는 모습을 볼 수 있는데,
그 사람들처럼 나도 저런 게임을 하고 싶다 혹은 퀴즈를 만들어서 다른 사람에게 풀어보게 하고 싶다는 생각이 들 때가 종종 있다.
그래서 쉽게 퀴즈를 만들 수 있고, 공유할 수 있는 앱이 있으면 재밌겠다는 생각을 바탕으로 기획을 하게 되었다.  
<br>

## 개발 기간과 v1.0 버전 기능
### 개발 기간
- 3/8 ~ 3/24 (약 16일)
- 업데이트 진행중
### Configuration
- 최소버전 16.0 / 라이트 모드 / 세로모드 / iOS전용
### v1.0 기능
1. 퀴즈 만들기 
  - 영화 검색 기능
  - 포스터 영역 선택 기능
  - 퀴즈 정보 저장 기능
  - 난이도 설정 기능
  - 다른 포스터로 교체 기능
<br>

2. 퀴즈 풀기
  - 애니메이션으로 영역 표시 기능
  - 정답 입력창이 키보드 위로 따라다니는 기능
  - 정답 및 오답 시 애니메이션 효과
<br>

### 업데이트 예정 목록 
  - 애니메이션 버그 수정
  - 초성 퀴즈
  - 영어 대응
  - 퀴즈 공유 기능 (GameKit)
  - 네트워크 단절 시 처리 기능
  - 퀴즈 풀 때 bgm
  - 퀴즈 힌트
  - 통계 기능 (DGChart)
<br>

### 기술 스택
- UIKit / MVVM / Custom Observable
- CollectionViewPagingLayout / SnapKit / CodeBaseUI
- Realm
- Alamofire / Decodable / Kingfisher
- SPM
<br>
<br>

# ⚒️트러블 슈팅
 역시 무에서 유를 처음 만드는 것은 많은 시행착오를 동반한다. UQuiz를 만들며 구현 과정에서 여러 문제들을 만났다. 아래는 그 문제들 중 어려웠던 문제들과 해결했던 방법을 설명해보려고 한다.

## 1. Realm에 Initial Data 넣기
 데이터베이스로 사용하는 Realm에 처음부터 내가 임의로 설정한 데이터를 넣고 싶어서 고민을 하게 되었다. 물론 간단한 데이터라면 하드코딩을 해서 넣어줄 수도 있다. 그러나 퀴즈 데이터와 같이 많은 데이터를 가지고 있는 경우라면 하드코딩으로 처리하기가 쉽지 않다. 그래서 realm 데이터를 Bundle에 추가해서 앱을 처음 시작할 때 데이터를 추가하는 방식을 활용했다.
<br>
[트러블 슈팅 블로그글](https://d0ngurrrrrrr.tistory.com/134)
<br>
<br>

## 2. 애니메이션 백그라운드 상태에서 포그라운드 상태로 돌아왔을 때 버그
 UIVIewPropertyAnimator을 활용해서 collectionViewCell의 색을 바꾸려고 했다. 그런데 앱이 백그라운드 상태로 갔다가 다시 포그라운드 상태로 돌아왔을 때, 애니메이션이 다 끝난 상태로 되어버리는 버그가 있었다. 이를 해결하기 위해 기존 진행율을 저장해 놓았다가 다시 애니메이션을 지정해 줘서 진행되게 하는 방법으로 문제를 해결했다.
<br>
[트러블 슈팅 블로그글](https://d0ngurrrrrrr.tistory.com/141)
<br>
<br>

## 3. CollectionViewPagingLayout 화면 reloadData가 안 되는 버그

 퀴즈 목록에서 중간 index의 퀴즈를 삭제하면 위와 같이 화면이 나타나는 버그가 있었다. 이 버그는 그냥 터치만 한번 해줘도 풀리는 버그였다. 하지만 이 버그는 눈에 잘 보이는 문제인 만큼 꽤나 치명적인 버그라고 생각했다. 해결 방법은 performBatchUpdates와 invalidateLayout이라는 메서드를 사용했다.
```
            self?.mainView.collectionView.reloadData()
            self?.mainView.collectionView.performBatchUpdates({
                self?.mainView.collectionView.collectionViewLayout.invalidateLayout()
            })
```
위 메서드들은 CollectionView의 레이아웃을 업데이트할 때, 특히 애니메이션과 함께 변경할 때 사용하는 메서드들로 '동적인 레이아웃 업데이트 시 사용'하거나 '애니메이션을 부드럽게 처리하는데' 사용한다고 한다. 즉 이런 버그는 UICollectionViewPagingLayout이라는 라이브러리를 활용해서 애니메이션과 동적인 레이아웃 UI를 구현해서 발생하는 버그였다.
<br>
<br>

## 4. BlurView가 사라지는 버그

 위 사진처럼 보이면 안 되는 이미지가 Blur가 사라지면서 보이게 되는 버그가 발생했다. 이를 해결하기 위한 방법 중 내가 아는 방법으로는 2가지 방법이 있다. 첫 번째는 CIFilter를 활용하는 방법이다. 두 번째 방법은 위 이미지를 Kingfisher로 가져오는 것이라 Kingfisher의 내장 기능 중 Blur를 처리해 주는 process를 사용하는 것이다. 이번 프로젝트에선 후자의 방법으로 위의 버그를 해결했다.
<br>
<br>


# 🤔회고
## 잘한 점
### 1. 같은 API라도 차별성이 있는지?
  기획적인 측면이겠지만, 같은 API라도 차별성이 있는 무언가를 할 수 있다. 예를 들어 영화 정보 API를 가지고 단순히 영화 정보를 가져오는 게 아니라, 영화 정보 등을 이용해 포스터 보고 영화 제목 맞추기 등 퀴즈를 맞히는 앱으로 만들 수 있다. 단순히 영화 정보를 보여주는 이미 존재하는 앱을 만드는 건 여러 측면에서 의미가 없다고 생각을 했다. (물론 코딩 능력의 성장은 가능하겠지만...) 그래서 기획에서부터 앱의 차별화를 두어 많은 사람들이 재밌게 사용할 수 있는 앱을 기획했다. 그래서 개인 앱 프로젝트로 새로운 걸 시도했다는 점에서, 진부해 보이는 API라도 새로운 기능을 제공하는 앱을 만들었다는 것에 의미가 있다고 생각한다.
<br>
<br>

### 2. 새로운 라이브러리 사용
 UICollectionViewPagingLayout 사용
  기존의 FSPager과 같은 유명한 라이브러리도 있었지만 이번 프로젝트에서는 비교적 덜 유명한 새로운 라이브러리를 사용해 보았다. 우선 이유는 크게 3가지가 있다. 첫째로 FSPager는 SPM을 지원하지 않는다. 둘째로 남들과는 차별화된 UI를 구현하고 싶었다. 마지막으로 새로운 라이브러리를 내가 직접 구현해 보며 도큐먼트를 잘 이해할 수 있는지, 남이 짠 코드를 내 것으로 만들어서 잘 적용할 수 있는지 테스트해보고 싶었다. 결과적으로 3개의 목적을 모두 달성했다. SPM을 활용하였고, 남들과는 차별화된 UI를 구현했으며, 도큐먼트와 샘플 코드 등을 활용해 어떻게 사용하는지 파악해서 구현에 성공했다. 이를 통해 개발자로서 성장도 할 수 있었다.
<br>
<br>

### 3. 이전에 받은 피드백을 고려했는지?
#### 3-1. Custom Observable를 활용할 때, 초기값을 넣어주면 실행되는 bind 메서드뿐만 아니라 다른 걸 만들어서 사용했는지?

 bind 뿐만 아니라 초기화할 때 값이 전달될 필요가 없을 경우를 위해 새로운 메서드를 만들어서 활용했다. 이 코드의 차이를 RxSwift로 치환해서 생각해 보자면 subscribe를 할 때의 PublishSubject와 BehaviorSubject의 차이가 될 수 있겠다. (혹시 아니라면 말해주세요..)
```
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
    
    func noInitBind(_ closure: @escaping (T) -> Void) {
        self.closure = closure
    }
```
<br>
<br>

#### 3-2. 모델을 만들 때, 모델을 생성하는 로직을 만들지 말고 이니셜라이저로 만들어보기

 영화 검색을 통해 받아온 데이터를 이니셜라이저를 이용해서 퀴즈 데이터로 치환을 하였다. 로직을 추가적으로 만들 필요 없이 효율적으로 데이터를 치환할 수 있었다.
<br>
<br>

#### 3-3. Alamofire Router 패턴 사용

  물론 Moya도 있지만 Alamofire에 URLRequestConvertible을 활용해서 Router 패턴을 구현하였다. 사용하면서 느낀 점은 메서드랑 path가 다양할수록 더 효과적인 패턴일 것이라는 생각이 들었다.

```
enum Router: URLRequestConvertible {
    case search([String: String])
    case posters(Int)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var headers: HTTPHeaders {
        return ["Authorization": APIKey.tmdb]
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        case .posters:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "search/movie"
        case .posters(let id):
            return "movie/\(id)/images"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case let .search(Parameters):
            request = try URLEncodedFormParameterEncoder().encode(Parameters, into: request)
        case .posters(_):
            return request
        }
        return request
    }
}
```
<br>
<br>

#### 3-4. Swift 성능 최적화를 위한 WMO

 앱의 최적화를 위해 Dynamic Dispatch를 줄이려고 메서드를 private으로 만들고 final을 class 앞에 붙였다. 이를 통해 각각의 파일이 어떻게 의존하고 있는지를 더 명확하게 하였고, 런타임 성능을 향상할 수 있게 하였다.
<br>
<br>

### 4. 꾸준히 개발일지를 작성했는지?
 블로그를 보면 알겠지만, 개인 프로젝트를 시작하고나서부터 꾸준히 주 6회 이상 개발을 하며 개발일지를 작성하였다. 물론 모든 고민들과 시행착오들이 모두 개발일지에 담기지는 않았지만, 되돌아보면 중간중간 어떤 문제로 어려움을 겪었는지 또 꾸준히 어떤 걸 새로 익혔는지 파악할 수 있었다. 
<br>
<br>

## 반성할 점
### 1. 라이브러리와 기능 구현 테스트를 통해 이슈를 미리 인지했는지?
 사실 이번 앱을 만들면서 가장 중요한 기능이 사용자가 포스터에서 보일 곳을 선택하게 하는 것과 처음 보는 라이브러리로 구현하는 UI였다. 선택하는 부분은 이런저런 방법을 고민하다가 CollectionView를 활용해서 구현을 하였다. (일주일 동안 이것저것 테스트를 해보았다.) 하지만 UICollectionViewPagingLayout 같은 경우에는 메인 뷰를 구현할 때가 돼서야 부랴부랴 구현을 해보았고, 그 과정에서 안되거나 각종 버그들 때문에 많은 시간을 소비했었다. 미리 테스트를 해보았다면 시간을 아끼고 다른 것에 공수를 더 투입할 수 있었을 텐데 말이다.

 이와 같은 맥락으로 공유 기능도 마찬가지이다. 공유기능을 넣을 때가 돼서야 구현에 들어갔고, 여러 공유 방법이 안된다는 것을 뒤늦게 알았다. 이것을 고민하고 테스트해 보느라 업데이트 기간을 3일가량 날려서 아쉬웠다. 
<br>
<br>


#### 2. 이전에 받은 피드백을 고려했는지?
아직 이전에 받은 피드백 중 수용 못한 부분들도 있다. 대표적으론 NWPathMonitor를 활용한 네트워크 상태를 감지하는 부분이 있다. 업데이트를 통해 구현할 것이지만 위의 반성할 점에서 시간을 좀 아껴서 구현했다면 충분히 처음 출시했을 때 포함할 수 있었다고 생각한다.

