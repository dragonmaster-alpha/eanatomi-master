class AddSliderTypeToTimelineEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :timeline_events, :slider_type, :text
  end
end
