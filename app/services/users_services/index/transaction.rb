module UsersServices
  module Index
    class Transaction < MainService
      step :validate_inputs
      step :get_items
      step :map_items

      def validate_inputs(params)
        validation = Contract.call(params.permit!.to_h)

        if validation.success?
          Success(params)
        else
          Failure[I18n.t('params.invalid'), validation.errors.to_h]
        end
      end

      def get_items(params)
        page = params[:page].present? ? params[:page].to_i : 1
        items = User.any_of(search_filter(params[:search]))
                    .order_by(name: :asc)
                    .paginate(page: page, per_page: 10)
        total_items = items.count
        Success[items, total_items, page]
      rescue 
        Failure(I18n.t('user.index.errors'))
      end

      def map_items(input)
        items = input[0]
        total_items = input[1]
        total_pages = ((total_items-1)/10)+1
        page = input[2]
        previous_page = if page>total_pages
                          total_pages 
                        elsif page==1
                          1
                        else
                          page-1
                        end
        next_page = page>=total_pages ? total_pages : page+1

        results = items.map do |item|
        {
          id: item.id.to_s,
          name: item.name,
          email: item.email,
          is_blocked: item.is_blocked,
          registered_at: item.created_at.strftime('%d/%m/%Y %H:%M')
        }
        end
        
        response = {
          total_items: total_items,
          total_pages: total_pages,
          page: page,
          previous_page: previous_page,
          next_page: next_page,
          results: results
        }
        Success(response)
      rescue
        Failure(I18n.t('user.index.errors'))
      end

      private

      def search_filter(key)
        [
          { name: /.*#{key}.*/i },
          { email: /.*#{key}.*/i }
        ]
      end

    end
  end
end
