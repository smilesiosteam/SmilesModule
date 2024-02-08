//
//  File.swift
//  
//
//  Created by Habib Rehman on 04/09/2023.
//

import Foundation
import SmilesSharedServices
import SmilesUtilities
import SmilesOffers
import SmilesBanners

extension SmilesExplorerHomeUpgradeViewModel {
    
   public enum Input {
       case getSections(categoryID: Int, type: String, explorerPackageType:ExplorerPackage,freeTicketAvailed:Bool,platinumLimiReached: Bool? = nil)
        case getRewardPoints
        case getFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?)
        case removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel)
        case getSortingList
        case generateActionContentForSortingItems(sortingModel: GetSortingListResponseModel?)
        case setFiltersSavedList(filtersSavedList: [RestaurantRequestWithNameFilter]?, filtersList: [RestaurantRequestFilter]?)
        case emptyOffersList
        case setSelectedSort(sortTitle: String?)
///        The value of Tag is the Section Identifier.
        case exclusiveDeals(categoryId: Int?, tag: String?,pageNo:Int?)
        case getExclusiveDealsStories(categoryId: Int?, tag: SectionTypeTag, pageNo: Int?)
        case getTickets(categoryId: Int?, tag: String?,pageNo:Int?)
     
        case getBogo(categoryId: Int?, tag: String?,pageNo:Int?)
        
        case getBogoOffers(categoryId: Int?, tag: SectionTypeTag,pageNo:Int?, categoryTypeIdsList: [String]? = nil)
        case updateOfferWishlistStatus(operation: Int, offerId: String)
        
        case getRestaurantList(pageNo : Int = 0, filtersList: [RestaurantRequestFilter]?, selectedSortingTableViewCellModel: FilterDO?)
        
        
        
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchFiltersDataSuccess(filters: [FiltersCollectionViewCellRevampModel], selectedSortingTableViewCellModel: FilterDO?)
        case fetchAllSavedFiltersSuccess(filtersList: [RestaurantRequestFilter], filtersSavedList: [RestaurantRequestWithNameFilter])
        
        case fetchRewardPointsDidSucceed(response: RewardPointsResponseModel, shouldLogout: Bool?)
        case fetchRewardPointsDidFail(error: Error)
        
        case fetchSavedFiltersAfterSuccess(filtersSavedList: [RestaurantRequestWithNameFilter])
        case fetchContentForSortingItems(baseRowModels: [BaseRowModel])
        
        case fetchSortingListDidSucceed
        case fetchSortingListDidFail(error: Error)
        
        case fetchTopOffersDidSucceed(response: GetTopOffersResponseModel)
        case fetchTopOffersDidFail(error: Error)
        
        case fetchExclusiveOffersDidSucceed(response: OffersCategoryResponseModel)
        case fetchExclusiveOffersDidFail(error: Error)
        
        case fetchExclusiveOffersStoriesDidSucceed(response: OffersCategoryResponseModel)
        case fetchExclusiveOffersStoriesDidFail(error: Error)
        
        case fetchTicketsDidSucceed(response: OffersCategoryResponseModel)
        case fetchTicketDidFail(error: Error)
        
        case fetchBogoDidSucceed(response: OffersCategoryResponseModel)
        case fetchBogoDidFail(error: Error)
        
        case fetchBogoOffersDidSucceed(response: OffersCategoryResponseModel)
        case fetchBogoOffersDidFail(error: Error)
        case updateHeaderView
        case updateWishlistStatusDidSucceed(response: WishListResponseModel)
        
        case fetchRestaurantListDidSucceed(response: GetRestaurantListingDOResponse)
        case fetchRestaurantListDidFail(error: Error)
        
        case emptyOffersListDidSucceed
        
        
    }
    
}
