

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
 
<details>
<summary>코드 보기</summary>
  
```
   func copyInitialRealm() {
   	let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("InitialData.realm")
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            let bundleURL = Bundle.main.url(forResource: "initial", withExtension: "realm")!
            
            do {
                try fileManager.copyItem(at: bundleURL, to: fileURL)
            } catch {
                print("Error copy file: \(error)")
            }
        }
    }
```
 bundle에 있는 realm 파일을 document 폴더에 저장한 후
```
 func fetchInitialData() {
       	let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("InitialData.realm")
 
        do {
            let initialRealm = try Realm(fileURL: fileURL)
            try realm.write {
                for object in initialRealm.objects(yourRealmModel.self) {
                    realm.create(yourRealmModel.self, value: object, update: .modified)
                }
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
```

document 폴더에 저장한 realm 파일을 불러와서 사용하였다.

</details>


<br>

[Realm 초기 데이터 사용하기 블로그글](https://d0ngurrrrrrr.tistory.com/134)
<br>
<br>

## 2. 애니메이션 백그라운드 상태에서 포그라운드 상태로 돌아왔을 때 버그
 UIVIewPropertyAnimator을 활용해서 collectionViewCell의 색을 바꾸려고 했다. 그런데 앱이 백그라운드 상태로 갔다가 다시 포그라운드 상태로 돌아왔을 때, 애니메이션이 다 끝난 상태로 되어버리는 버그가 있었다. 이를 해결하기 위해 기존 진행율을 저장해 놓았다가 다시 애니메이션을 지정해 줘서 진행되게 하는 방법으로 문제를 해결했다.
<br>

<details>
<summary>코드 보기</summary>

```
	// SceneDelegate
func sceneDidEnterBackground(_ scene: UIScene) {
   NotificationCenter.default.post(name: Notification.Name("SceneResign"), object: nil, userInfo: ["willResign": true])
}
```
SceneDelegate에서 백그라운드 상태로 전환될 때를 케치

```
// 애니메이션을 실행한 ViewController에서
override func ViewDidLoad() {
	  NotificationCenter.default.addObserver(self, selector: #selector(sceneResignStatusNotification), name: NSNotification.Name("SceneResign"), object: nil)
}
 
// MARK: NotificationCenter (백그라운드 상태로 변화할때)
@objc private func sceneResignStatusNotification(notification: NSNotification) {
   if let value = notification.userInfo?["willResign"] as? Bool {
       isBackground = true
       pauseAnimations()
   }
}
```
애니메이션이 진행중이던 뷰컨트롤러에서 백그라운드 상태로 전환될 때, 애니메이션을 중지

```
    // UIViewPropertyAnimator 객체를 저장한 배열
    var animators: [UIViewPropertyAnimator] = []
    // 애니메이션 진행률 저장 
    var animatorProgress: [CGFloat] = []
    
	private func resumeAnimations() {
        
        // 애니메이션이 완료되면 1.0이 아닌 0으로 저장이 되기 때문에, 0이 아닌 애니메이션을 찾음
        guard let lastIndex = animatorProgress.firstIndex(where: { $0 != 0 }) else { return }
        let nextIndex = lastIndex + 1
        // 애니메이션이 표시될 cell 정보가 기억된 배열
        let list = Array(viewModel.outputQuizList.value[viewModel.outputCurrentIndex.value].selectedArea)
        let listLastIndex = list.count - 1
        
        // 백그라운드 상태인지 아닌지 Bool 값으로 구별
        if isBackground {
            
            // 마지막 애니메이션의 보이는 정도 복구
            for index in Array(list[lastIndex].area) {
                let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                cell?.backgroundColor = .black.withAlphaComponent(1 - animatorProgress[lastIndex])
            }
            // 아직 안보이는 부분 검은색으로 다시 칠하기
            for restIndex in lastIndex + 1...listLastIndex {
                let areaList = list[restIndex]
                let areaIndex = Array(areaList.area)
                for index in areaIndex {
                    let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                    cell?.backgroundColor = .black
                }
                // 애니메이션 다시 지정
                let animator = UIViewPropertyAnimator(duration: TimeInterval(2), curve: .linear) {
                    for index in areaIndex {
                        let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                        cell?.backgroundColor = .clear
                    }
                }
                animators[restIndex] = animator
            }
 
            // 진행율로 애니메이션 남은 시간 계산하기
            let restTime: CGFloat = CGFloat(2) * (1 - animatorProgress[lastIndex])
            // 마지막 애니메이션 진행중인 곳에 애니메이션 주기
            let animator = UIViewPropertyAnimator(duration: Double(restTime), curve: .linear) {
                for index in Array(list[lastIndex].area) {
                    let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                    cell?.backgroundColor = .clear
                }
            }
            animators[lastIndex] = animator
        }
        // 마지막 애니메이션 시작하기
        animators[lastIndex].startAnimation()
        // 애니메이션이 끝나면 그 다음 애니메이션 시작
        animators[lastIndex].addCompletion { position in
            if position == .end {
                self.startNextAnimation(index: nextIndex)
            }
        }
    }
```
포그라운드 상태로 돌아왔을 때, 애니메이션을 다시 시작

</details>

[트러블 슈팅 블로그글](https://d0ngurrrrrrr.tistory.com/141)
<br>
<br>

## 3. CollectionViewPagingLayout 화면 reloadData가 안 되는 버그
<p align="center">
<img width="24%" src="https://github.com/Greeddk/UQuiz/assets/116425551/0e0b07c0-578c-43be-a8d7-27b18b7231e5"/>  
</p>

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
<p align="center">
<img width="24%" src="https://github.com/Greeddk/UQuiz/assets/116425551/1f480fa1-753f-4899-bd80-304d82e4d487"/>
</p>

 위 사진처럼 보이면 안 되는 이미지가 Blur가 사라지면서 보이게 되는 버그가 발생했다. 이를 해결하기 위한 방법 중 내가 아는 방법으로는 2가지 방법이 있다. 첫 번째는 CIFilter를 활용하는 방법이다. 두 번째 방법은 위 이미지를 Kingfisher로 가져오는 것이라 Kingfisher의 내장 기능 중 Blur를 처리해 주는 process를 사용하는 것이다. 이번 프로젝트에선 후자의 방법으로 위의 버그를 해결했다.
 ```
  let url = PosterURL.thumbnailURL(detailURL: detailURL).endpoint
  let processor = BlurImageProcessor(blurRadius: 20.0)
  posterView.kf.setImage(with: url, options: [.processor(processor)])
```
<br>
<br>
