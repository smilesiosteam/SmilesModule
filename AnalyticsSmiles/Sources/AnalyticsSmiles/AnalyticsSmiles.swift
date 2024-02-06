import Combine

public final class AnalyticsSmiles {
    public private(set) var service : AnalyticService
    
    var subscriptions = Set<AnyCancellable>()
    
    public init(service: AnalyticService) {
        self.service = service
    }
    
    public func sendAnalyticTracker<TrackerData: EventTrackerData>(trackerData: TrackerData) {
        service.sendAnalyticTracker(trackerData: trackerData)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("oops got an error \(error.localizedDescription)")
                case .finished:
                    print("nothing much to do here")
                }
            } receiveValue: { (response) in
                print("got my response here \(response)")
                if response {
                    // Send back any closure if required.
                }
            }
            .store(in: &subscriptions)
    }
}



